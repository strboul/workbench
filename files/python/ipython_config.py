from IPython.terminal.prompts import Prompts, Token

# TODO: double check those class method arguments, if needed?


class MyPrompts(Prompts):
    def in_prompt_tokens(self, cli=None):
        return [(Token.Prompt, ">>> ")]

    def continuation_prompt_tokens(self, cli=None, width=None):
        if width is None:
            width = 0
        return [(Token.Prompt, "... ".rjust(width))]

    def out_prompt_tokens(self, cli=None):
        return []


c = get_config()  # noqa: F821

c.InteractiveShell.prompts_class = MyPrompts
c.TerminalInteractiveShell.highlighting_style_overrides = {
    Token.Prompt: "#ffffff bold",
}
c.InteractiveShell.autoindent = False
c.InteractiveShell.separate_in = "\n"
c.InteractiveShell.colors = "Neutral"
