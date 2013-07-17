/*                This file is part of the scheme package.
            Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
                 http://www.essi.fr/~hillion/scheme-package
   scheme package is free software. You can redistribute it and/or modify it 
  under the terms of the GNU General Public License as published by the Free
  Software  Foundation;  either  version  2, or (at your option)  any  later 
  version. The  scheme package  is distributed in the hope that  it will  be
  useful, but  WITHOUT ANY WARRANTY;  without  even  the implied warranty of
  MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
  Public License for  more  details.   You  should  have  received a copy of
  the GNU General Public  License  along  with the scheme package;   see the
  file COPYING.  If not,  write to the Free  Software  Foundation,  Inc., 59
  Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/
package scheme.extensions;

import scheme.kernel.*;

/**
 * The execution of this procedure cause the autoloading of the
 * symbol given on creation
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/12/12
 */
public class ScmAutoload extends ScmPredefined {
  /** The symbol to load in a file */
  private ScmSymbol symbol;

  /** The file to load */
  private String fname;

  /**
   * The constructor
   * @param symb the autoloadable symbol
   * @param name the name of the file to load
   */
  public ScmAutoload (ScmSymbol symb, String name) {
    symbol = symb;
    fname  = name;
  }

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    // File loading
    //
    ScmInputPort port = new ScmInputPort (fname);
    ScmParser parser = new ScmParser (port.getReader());
    ScmObject obj    = parser.read();
    ScmStack  e      = new ScmStack ();
    e.push (envs.firstElement());

    while (obj != null) {
	ScmKernel.evalAux2 (obj, e);
	obj = parser.read();
    }
    port.close();

    ScmObject proc = ((ScmEnvironment)envs.firstElement()).find (symbol);
    return toProcedure (proc).call (args, envs);
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[autoload "+symbol+"]";
  }
}
