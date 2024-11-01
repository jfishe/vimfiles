"""Vim-pandoc extension for Vim-Zettel, Vimwiki and Markdown."""

import re
import vim
from vim_pandoc.command import pandoc

cmd: str = (
    "markdown --from=markdown+wikilinks_title_after_pipe-task_lists "
    "--standalone --wrap=none"
)


def wikilink_md(cmd: str = cmd):
    """Convert Vimwiki-syntax-links to Markdown.

    Parameters
    ----------
    cmd : TODO

    Returns
    -------
    TODO

    """
    outfile = vim.eval('expand("%")')
    pandoc(cmd, False)
    pattern: str = r"\\\[(\S|\s)\\]"
    repl: str = r"[\1]"
    with open(outfile, "r") as f:
        string = f.read()

    result = re.sub(
        pattern,
        repl,
        string,
        0,
        re.MULTILINE,
    )

    __import__('pprint').pprint(result)
    with open(outfile, "w") as f:
        f.write(result)

    return result
