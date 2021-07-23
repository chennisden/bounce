# Packages you need

In 2021, I wrote several packages partially for the purpose of including them in this class (as well as other classes I develop): `ifallfalse`, `macrolist`, and `palette`, which I have or will publish to CTAN. The class depends on these packages to compile, so make sure you have them. Run

    tlmgr install packagename

to install `packagename`.

However, TeX Live takes up to a few days to update these packages, and because this class is undergoing quite rapid development, it is highly recommended you clone these styles instead. For Unix-like systems, you may want to consider installing the following scripts onto your own system. (I do not actually distribute these scripts inside the package for a couple of reasons, principally because these scripts are incredibly short, will serve no function in `texmf`, and will be changed fairly often.)

## Install (clone) script

If you change your TEXMFHOME variable and do not manually move bounce and its dependencies over, you should use the install script again.

  #! /usr/bin/bash

  DEP=(ifallfalse macrolist palette) # Dependencies

  clone(){
    git clone "https://github.com/chennisden/$1"
  }

  TEXMF=$(kpsewhich --var-value TEXMFHOME)
  if [ ! -d "$TEXMF/tex/latex" ]
  then
    mkdir "$TEXMF/tex/latex"
  fi
  cd "$TEXMF/tex/latex"

  for d in ${DEP[@]}; do
    clone $d
  done

## Update (pull) script

This might as well be identical to the clone script.

  #! /usr/bin/bash

  DEP=(ifallfalse macrolist palette) # Dependencies

  pull(){
    git pull "https://github.com/chennisden/$1"
  }

  TEXMF=$(kpsewhich --var-value TEXMFHOME)
  if [ ! -d "$TEXMF/tex/latex" ]
  then
    mkdir "$TEXMF/tex/latex"
  fi
  cd "$TEXMF/tex/latex"

  for d in ${DEP[@]}; do
    pull $d
  done

# Summary

This is not a completed class; please keep this in mind when using it. The article is _mostly_ done, but refinements can be made to `bubblepage.sty`. The book needs serious revision (though you can still write LaTeX code and just wait for us to refine the visuals).

## To be done

As said before, `bubblepage.sty` may need refinements.

The book class needs work; I would appreciate anyone who could help on it. In particular,

- the chapter headings are OK (may want further revision),
- the part formatting is not done,
- and nor is the chapter formatting.
  Our current work can be seen on the part and chapter branches, but be warned: it is not good.

You can check out chapter headings and part formatting in the `chapter` and `part` branches; the `chapterhead` branch may become useful later but it has been merged into `main`.

What would also be helpful is documentation and examples.

# Contents

- `README.md` this file
- `bounce.cls` main class
- `bubblepage.sty` supporting package that draws bubbles on titlepage
- `prob.sty` supporting package to format problems
- `solprint.sty` supporting package to associate solutions with environments and print out solutions (similar to answers.sty)
