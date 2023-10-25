--https://sookocheff.com/post/vim/neovim-java-ide/
local jdtls = require('jdtls')
local home = os.getenv('HOME')
-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local bundles = {
    vim.fn.glob(
        '/home/bournas/tools/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'),
}
vim.list_extend(bundles, vim.split(vim.fn.glob('/home/bournas/tools/vscode-java-test/server/*.jar'), "\n"))

-- The nvim-cmp supports additional LSP's capabilities so we need to
-- advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = {
    --cmd = {'/home/bournas/tools/jdtls/bin/jdtls'},
    -- cmd is the command that starts the language server. Whatever is placed
    -- here is what is passed to the command line to execute jdtls.
    -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    -- for the full list of options
    cmd = {
        "/usr/lib/jvm/java-17-openjdk-amd64/bin/java",
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
        --'-javaagent:' .. home .. '/.local/share/eclipse/lombok.jar',

        -- The jar file is located where jdtls was installed. This will need to be updated
        -- to the location where you installed jdtls
        '-jar', vim.fn.glob('/home/bournas/tools/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

        -- The configuration for jdtls is also placed where jdtls was installed. This will
        -- need to be updated depending on your environment
        '-configuration', '/home/bournas/tools/jdtls/config_linux',

        -- Use the workspace_folder defined above to store data for this project
        '-data', workspace_folder,
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        require('ody.lsp').on_attach(client, bufnr, {
            server_side_fuzzy_completion = true,
        })
        -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
        -- you make during a debug session immediately.
        -- Remove the option if you do not want that.
        -- You can use the `JdtHotcodeReplace` command to trigger it manually
        jdtls.setup_dap({ hotcodereplace = 'auto' })
        jdtls.setup.add_commands()

        local opts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', "<leader>o", jdtls.organize_imports, opts)
        vim.keymap.set('n', "<leader>df", jdtls.test_class, opts)
        vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, opts)
        vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
        vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
        vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
        --local create_command = vim.api.nvim_buf_create_user_command
        --create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
        --nargs = 0,
        --})
    end,
    --The on_attach function is used to set key maps after the language server
    --attaches to the current buffer
    --local on_attach = function(client, bufnr)
    --Regular Neovim LSP client keymappings
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    --nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
    --nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
    --nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
    --nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
    --nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
    --nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
    --nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
    --nnoremap('<space>wl', function()
    --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts, "List workspace folders")
    --nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
    --nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
    --nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "Code actions")
    --vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    --{ noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
    --nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")

    --Java extensions provided by jdtls
    --nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
    --nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
    --nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
    --vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>,
    --{ noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
    --end
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })[1]),
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
    settings = {
        java = {
            eclipse = {
                downloadSources = true
            },
            maven = {
                downloadSources = true
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                settings = {
                    -- Use ANV Java style guidelines for formatting
                    -- To use Google's, make sure to download the file from
                    -- https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                    -- and place it in the ~/.local/share/eclipse directory
                    url = "/.local/share/eclipse/Java_Conventions_ANV_Final.xml",
                    profile = "ANVStyle",
                },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/java/jdk-11",
                    }
                    --,
                    --{
                        --name = "JavaSE-17",
                        --path = "/usr/lib/jvm/java-17-openjdk-amd64"
                    --}
                },
                updateBuildConfiguration = "interactive",
            },
        },
    },
    init_options = {
        bundles = bundles
    }
}
--require "dap".configurations.java = {
--{
--type = 'java',
--request = 'attach',
--name = "Debug (Attach) - Remote",
--hostName = "127.0.0.1",
--port = 8000,
--},
--}

require('jdtls').start_or_attach(config)

--local jdtls = require('jdtls')
--local root_markers = {'gradlew', '.git'}
--local root_dir = require('jdtls.setup').find_root(root_markers)
--local home = os.getenv('HOME')
--local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
--local config = require('me.lsp.conf').mk_config()
--config.settings = {
--java = {
--signatureHelp = { enabled = true };
--contentProvider = { preferred = 'fernflower' };
--completion = {
--favoriteStaticMembers = {
--"org.hamcrest.MatcherAssert.assertThat",
--"org.hamcrest.Matchers.*",
--"org.hamcrest.CoreMatchers.*",
--"org.junit.jupiter.api.Assertions.*",
--"java.util.Objects.requireNonNull",
--"java.util.Objects.requireNonNullElse",
--"org.mockito.Mockito.*"
--},
--filteredTypes = {
--"com.sun.*",
--"io.micrometer.shaded.*",
--"java.awt.*",
--"jdk.*",
--"sun.*",
--},
--};
--sources = {
--organizeImports = {
--starThreshold = 9999;
--staticStarThreshold = 9999;
--};
--};
--codeGeneration = {
--toString = {
--template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
--},
--hashCodeEquals = {
--useJava7Objects = true,
--},
--useBlocks = true,
--};
--configuration = {
--runtimes = {
--{
--name = "JavaSE-11",
--path = "/java/jdk-11/bin/java",
--},
--{
--name = "JavaSE-17",
--path = home .. "/usr/lib/jvm/java-17-openjdk-amd64/bin/java",
--},
--}
--};
--};
--}
--config.cmd = {
--home .. "/usr/lib/jvm/java-17-openjdk-amd64/bin/java",
--'-Declipse.application=org.eclipse.jdt.ls.core.id1',
--'-Dosgi.bundles.defaultStartLevel=4',
--'-Declipse.product=org.eclipse.jdt.ls.core.product',
--'-Dlog.protocol=true',
--'-Dlog.level=ALL',
--'-Xmx4g',
--'--add-modules=ALL-SYSTEM',
--'--add-opens', 'java.base/java.util=ALL-UNNAMED',
--'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
--'-jar', vim.fn.glob(home .. '/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar'),
--'-configuration', home .. '/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux',
--'-data', workspace_folder,
--}
--config.on_attach = function(client, bufnr)
--require('me.lsp.conf').on_attach(client, bufnr, {
--server_side_fuzzy_completion = true,
--})

--jdtls.setup_dap({hotcodereplace = 'auto'})
--jdtls.setup.add_commands()
--local opts = { silent = true, buffer = bufnr }
--vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts)
--vim.keymap.set('n', "<leader>df", jdtls.test_class, opts)
--vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, opts)
--vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
--vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
--vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
--local create_command = vim.api.nvim_buf_create_user_command
--create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
--nargs = 0,
--})
--end

--local jar_patterns = {
--'/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
--'/dev/dgileadi/vscode-java-decompiler/server/*.jar',
--'/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar',
--'/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
--'/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar',
--'/dev/testforstephen/vscode-pde/server/*.jar'
--}
---- npm install broke for me: https://github.com/npm/cli/issues/2508
---- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
--local plugin_path = '/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/'
--local bundle_list = vim.tbl_map(
--function(x) return require('jdtls.path').join(plugin_path, x) end,
--{
--'org.eclipse.jdt.junit4.runtime_*.jar',
--'org.eclipse.jdt.junit5.runtime_*.jar',
--'org.junit.jupiter.api*.jar',
--'org.junit.jupiter.engine*.jar',
--'org.junit.jupiter.migrationsupport*.jar',
--'org.junit.jupiter.params*.jar',
--'org.junit.vintage.engine*.jar',
--'org.opentest4j*.jar',
--'org.junit.platform.commons*.jar',
--'org.junit.platform.engine*.jar',
--'org.junit.platform.launcher*.jar',
--'org.junit.platform.runner*.jar',
--'org.junit.platform.suite.api*.jar',
--'org.apiguardian*.jar'
--}
--)
--vim.list_extend(jar_patterns, bundle_list)
--local bundles = {}
--for _, jar_pattern in ipairs(jar_patterns) do
--for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
--if not vim.endswith(bundle, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
--and not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
--table.insert(bundles, bundle)
--end
--end
--end
--local extendedClientCapabilities = jdtls.extendedClientCapabilities;
--extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
--config.init_options = {
--bundles = bundles;
--extendedClientCapabilities = extendedClientCapabilities;
--}
---- mute; having progress reports is enough
--config.handlers['language/status'] = function() end
--jdtls.start_or_attach(config)
