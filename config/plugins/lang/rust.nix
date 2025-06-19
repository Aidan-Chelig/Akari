{
  self,
  pkgs,
  lib,
  ...
}:
{
  plugins = {

    lsp.servers.rust_analyzer = {
      enable = true;

      installCargo = false;
      installRustc = false;
    };

    dap = {
      adapters.executables.codelldb = {
        command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        args = [
          "--port"
          "\${port}"
        ];
      };

      adapters.servers.codelldb = {
        host = "127.0.0.1";
        port = "\${port}";
      };

      adapters.executables.rustlldb = {
        command = "${pkgs.lldb}/bin/lldb-dap";
        options = {
          env = {
            LD_LIBRARY_PATH = "\${workspaceFolder}/target/debug/deps:\$LD_LIBRARY_PATH";
          };
        };
      };

      configurations.rust = [
        {
          stopOnEntry = false;
          name = "rust";
          type = "rustlldb";
          request = "launch";
          cwd = "\${workspaceFolder}";
          program.__raw = ''
            function()
              return vim.fn.input('Executable path: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end
          '';
        }
      ];
    };
  };
}
