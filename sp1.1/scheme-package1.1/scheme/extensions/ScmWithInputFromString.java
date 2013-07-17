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

import java.io.*;
import scheme.kernel.*;

/**
 * The Scheme language with-input-from-string procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/12/10
 */
public class ScmWithInputFromString extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmWithInputFromString INSTANCE = new ScmWithInputFromString ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 2)
      error ("2 arguments expected");
    
    ScmInputPort port = new ScmInputPort 
	(new StringReader (toScmString(args.get(0)).toStringWithoutQuotes()));
    ScmProcedure p = toProcedure (args.get(1));

    ScmPair   exp = new ScmPair (p, ScmPair.NULL);

    ScmInputPort ip = ScmInputPort.current;
    ScmInputPort.current = port;

    ScmObject res = ScmKernel.evalAux1 (exp, envs);

    ScmInputPort.current = ip;

    return res;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive with-input-from-string]";
  }
}
