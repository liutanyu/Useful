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
package scheme.java;

import java.awt.event.*;
import scheme.kernel.*;
import scheme.extensions.*;

/**
 * This class is used as an action adapter by the scheme system
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/30
 */
public class ScmActionListener implements ActionListener {
    /** The calling Scheme kernel */
    private ScmKernel kernel;

    /** The expression to evaluate at each action */
    private ScmProcedure procedure;

    /**
     * Create a new listener
     */
    public ScmActionListener (Object ker, Object proc) {
	kernel    = (ScmKernel)ker;
	procedure = (ScmProcedure)proc;
    }

    /**
     * The action
     */
    public void actionPerformed (ActionEvent ev) {
	try {
	    kernel.eval (new ScmPair(procedure, 
				     new ScmPair (new ScmJavaObject (ev),
						  ScmPair.NULL)));
	} catch (ScmException ex) {
	    System.out.println ("Error in actionPerformed: "+ex);
	}
    }
}
