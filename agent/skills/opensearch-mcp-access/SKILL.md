---
name: opensearch-mcp-access
description: >-
  Use when searching OpenSearch/Kibana/IndexSearch/logstash, reading cluster
  logs, querying indices, or using the local OpenSearch MCP at
  http://127.0.0.1:9900/mcp. Use when OpenSearch is missing from mcp.json but
  the Streamable HTTP MCP server is running. Not for changing ~/.cursor/mcp.json.
---

# OpenSearch MCP access

A dedicated OpenSearch MCP server is already running locally at:

http://127.0.0.1:9900/mcp

Health endpoint:

http://127.0.0.1:9900/health

## Important configuration rule

This server is intentionally NOT registered in ~/.cursor/mcp.json or the project .cursor/mcp.json.

Do not modify either MCP configuration file to add this server unless I explicitly ask you to.

The absence of the server from mcp.json does NOT mean OpenSearch is unavailable.

## How to use OpenSearch

When an OpenSearch operation is needed:

First check the tools currently exposed in your Cursor session.

If native OpenSearch MCP tools are available, use them directly.

If native OpenSearch MCP tools are NOT available, use the running Streamable HTTP MCP server at:
http://127.0.0.1:9900/mcp

Communicate with that endpoint using the MCP protocol from the shell/network capabilities available to you.

Do NOT fall back to saying "OpenSearch is unavailable" merely because it is absent from mcp.json.

Do NOT invent tool names. Discover the actual tools exposed by the MCP server when necessary.

Do NOT start another OpenSearch MCP server. The existing server is already running.

Prefer this MCP server over directly querying OpenSearch, Elasticsearch, Kubernetes, or other underlying systems when the MCP server provides the required capability.

## HTTP MCP client (when native tools are absent)

Run from anywhere. Do not paste protocol envelopes into the conversation.

```bash
SCRIPT="$HOME/.agent/skills/opensearch-mcp-access/scripts/opensearch_mcp.py"
# fallback if not yet linked:
# SCRIPT="$HOME/programming/aux/.dotfiles/agent/skills/opensearch-mcp-access/scripts/opensearch_mcp.py"

python3 "$SCRIPT" health
python3 "$SCRIPT" tools
python3 "$SCRIPT" call SearchIndexTool '{"index":"logstash-2026.11.06","query_dsl":"{...}","size":20}'
python3 "$SCRIPT" call GenericOpenSearchApiTool '{"path":"/logstash-*/_search","method":"POST","body":{}}'
```

`tools` writes names/schemas to `~/.local/state/opensearch-mcp-stream/tools.json`. Discover once per task; reuse names after that.

## Minimize token and tool overhead

Optimize OpenSearch interactions for minimal context and token usage.

Do not rediscover the MCP tools before every query.

Discover the available tools once and reuse their names/schemas during the current task/session whenever possible.

Reuse the MCP session when the protocol/server supports it.

Do not repeatedly initialize a new MCP session if an existing session can be reused.

Do not print raw MCP JSON, protocol messages, HTTP headers, or session details unless debugging is specifically requested.

Request only the fields needed to answer the question.

Apply filtering, sorting, aggregation, and limits server-side whenever possible.

Prefer a small size/limit over retrieving large result sets and filtering them in the agent.

For log investigations, filter by timestamp, container/pod identifier, severity, application, or message on the server side whenever possible.

Do not retrieve thousands of documents when the question can be answered with tens of documents or an aggregation.

If an aggregation can answer the question, prefer the aggregation over fetching individual documents.

Do not repeatedly query the same information if it is already available in the current context.

Keep intermediate tool output concise.

Only present the relevant results to me.

## Query behavior

For every OpenSearch request:

Determine exactly what information is needed.

Translate the request into the smallest useful OpenSearch query.

Apply server-side filtering and limits.

Execute the query through the native MCP tool or the HTTP MCP server.

Inspect the returned data.

If additional data is genuinely required, make a targeted follow-up query.

Otherwise, answer directly from the retrieved data.

Do not merely tell me how an OpenSearch query could be performed. Actually perform it.

## Failure handling

If the HTTP MCP endpoint is unavailable:

Check http://127.0.0.1:9900/health.

Determine whether the MCP server is running.

Diagnose the actual connection/protocol problem.

Only report OpenSearch as unavailable if the server genuinely cannot be reached or used.

Do not interpret "not present in mcp.json" as a connection failure.

If health fails, the operator starts the existing helper with `opensearch-mcp-stream start` (do not invent a second server).

## Important distinction

Native Cursor MCP tools and HTTP access to the MCP server are two different mechanisms:

Native MCP tools available: use them directly.

Native MCP tools unavailable: use the running HTTP MCP endpoint.

Never claim native MCP tools are available when they are not.

Never claim OpenSearch is unavailable simply because native MCP tools are not exposed.

The goal is to make effective use of the existing OpenSearch MCP server while keeping tool calls, context usage, and token consumption as low as reasonably possible.

## Log indices (Altiplano)

Daily app/k8s logs live in `logstash-YYYY.MM.DD`. Typical tools: `ListIndexTool`, `IndexMappingTool`, `SearchIndexTool`, `GenericOpenSearchApiTool`, `CountTool`.

Pod replica identity is `container_id` (keyword), e.g. `automation-av2-altiplano-ipfixbecollector-7bc899f57f-m8nkc_20261105-145600`. `container_name` is often the Deployment name without the replica suffix. Kube events may use `container_name` with a `.<uid>` suffix and `event.involvedObject.name` for the pod.

Useful `_source` fields: `date`, `level`, `application`, `message`, `container_id`, `container_name`, `thread`, `throwable`.

Date field is `date`. Sort `date desc`. Cap `size` at tens unless asked for more.

## Common mistakes

| Excuse | Reality |
|--------|---------|
| "Not in mcp.json so OpenSearch is down" | Server is at 127.0.0.1:9900; use HTTP MCP. |
| "I should add it to mcp.json" | Do not, unless explicitly asked. |
| "I'll kubectl logs instead" | Prefer MCP when it can answer. |
| "I'll dump tools/list every query" | Discover once; reuse. |
| "I'll print the SSE envelope" | Use `opensearch_mcp.py`; show only answer fields. |
