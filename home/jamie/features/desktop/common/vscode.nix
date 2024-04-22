{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
      eamodio.gitlens
    ];
    userSettings = {
      "editor.fontFamily" = "'CaskaydiaCove NF Mono'";
      "editor.fontLigatures" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.renderIndentGuides" = true;
      "editor.renderWhitespace" = "all";
      "editor.suggestSelection" = "first";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";

      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      "workbench.colorTheme" = "Nord";
      "workbench.startupEditor" = "none";

      "window.titleBarStyle" = "custom";

      "files.autoSave" = "afterDelay";

      "breadcrumbs.enabled" = true;

      "github.copilot.enable" = {
        "*" = true;
        "markdown" = true;
      };
    };
  };
}
