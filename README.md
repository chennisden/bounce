# Summary

This is not a completed class; please keep this in mind when using it. The article is *mostly* done, but refinements can be made to `bubblepage.sty`. The book needs serious revision (though you can still write LaTeX code and just wait for us to refine the visuals).

## To be done

As said before, `bubblepage.sty` may need refinements.

The book class needs work; I would appreciate anyone who could help on it. In particular,
- the chapter headings are OK (may want further revision),
- the part formatting is not done,
- and nor is the chapter formatting.
Our current work can be seen on the part and chapter branches, but be warned: it is not good.

What would also be helpful is documentation and examples.

# Contents

- `README.md` this file
- `texmf/tex/latex/` formatted this way because likely to be many changes; `git pull` directly working is ideal
    * `bounce.cls` main class
    * `bubblepage.sty` supporting package that draws bubbles on titlepage
    * `prob.sty` supporting package to format problems
    * `solprint.sty` supporting package to associate solutions with environments and print out solutions (similar to answers.sty)
- `documentation` (does not exist yet) contains examples and documentation
