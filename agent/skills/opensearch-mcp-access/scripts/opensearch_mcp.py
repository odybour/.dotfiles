#!/usr/bin/env python3
"""Compact Streamable HTTP client for the local OpenSearch MCP server.

Usage:
  opensearch_mcp.py health
  opensearch_mcp.py tools
  opensearch_mcp.py call <ToolName> '<json-arguments>'

Prints only tool text (or a one-line error). Does not print MCP envelopes.
"""
from __future__ import annotations

import json
import sys
import urllib.error
import urllib.request
from pathlib import Path

MCP_URL = "http://127.0.0.1:9900/mcp"
HEALTH_URL = "http://127.0.0.1:9900/health"
STATE_DIR = Path.home() / ".local" / "state" / "opensearch-mcp-stream"
TOOLS_CACHE = STATE_DIR / "tools.json"


def _post(payload: dict) -> dict:
    req = urllib.request.Request(
        MCP_URL,
        data=json.dumps(payload).encode(),
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        },
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        body = resp.read().decode()
    for line in body.splitlines():
        if line.startswith("data: "):
            return json.loads(line[6:])
    if body.strip().startswith("{"):
        return json.loads(body)
    raise RuntimeError(f"unrecognized MCP response ({len(body)} bytes)")


def _result_text(msg: dict) -> str:
    if "error" in msg:
        err = msg["error"]
        return f"MCP error: {err}"
    result = msg.get("result") or {}
    if result.get("isError"):
        parts = result.get("content") or []
        texts = [p.get("text", "") for p in parts if isinstance(p, dict)]
        return "MCP tool error: " + "\n".join(texts)
    content = result.get("content")
    if isinstance(content, list):
        texts = [p.get("text", "") for p in content if isinstance(p, dict)]
        return "\n".join(texts)
    if content is None and result:
        return json.dumps(result, separators=(",", ":"))
    return str(result)


def cmd_health() -> int:
    try:
        with urllib.request.urlopen(HEALTH_URL, timeout=5) as resp:
            print(resp.read().decode().strip() or "OK")
        return 0
    except urllib.error.URLError as exc:
        print(f"health unreachable: {exc}", file=sys.stderr)
        return 1


def cmd_tools() -> int:
    msg = _post({"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}})
    tools = ((msg.get("result") or {}).get("tools")) or []
    names = []
    slim = []
    for t in tools:
        name = t.get("name")
        names.append(name)
        slim.append(
            {
                "name": name,
                "description": t.get("description", ""),
                "inputSchema": t.get("inputSchema"),
            }
        )
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    TOOLS_CACHE.write_text(json.dumps(slim, indent=2))
    print("\n".join(str(n) for n in names))
    return 0


def cmd_call(name: str, args_json: str) -> int:
    try:
        arguments = json.loads(args_json) if args_json else {}
    except json.JSONDecodeError as exc:
        print(f"invalid JSON arguments: {exc}", file=sys.stderr)
        return 2
    if not isinstance(arguments, dict):
        print("arguments must be a JSON object", file=sys.stderr)
        return 2
    msg = _post(
        {
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": {"name": name, "arguments": arguments},
        }
    )
    print(_result_text(msg))
    return 0


def main(argv: list[str]) -> int:
    if len(argv) < 2 or argv[1] in {"-h", "--help"}:
        print(__doc__.strip())
        return 0
    cmd = argv[1]
    try:
        if cmd == "health":
            return cmd_health()
        if cmd == "tools":
            return cmd_tools()
        if cmd == "call" and len(argv) >= 3:
            args = argv[3] if len(argv) > 3 else "{}"
            return cmd_call(argv[2], args)
        print(__doc__.strip(), file=sys.stderr)
        return 2
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code} from {MCP_URL}", file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"MCP unreachable at {MCP_URL}: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
