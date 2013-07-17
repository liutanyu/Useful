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
import scheme.kernel.*;
import scheme.extensions.*;
import java.io.*;

/**
 * ScmLoader
 * Loads and runs the files given on the command line
 *
 * @author Stephane Hillion
 * @version 1.1 - 1998/12/24
 */
public class ScmLoader {
    private final static String STARTING_MESSAGE =
	"\n  ---------------------------------------------------------\n"+
	"     S c h e m e  L o a d e r  1.1 (C) 1998 - S.Hillion    \n"+
	"  ---------------------------------------------------------\n";

    public static void main (String [] args) throws Exception {
	try {
	    System.out.println (STARTING_MESSAGE);
	    if (args.length < 1) {
		System.out.println ("ScmLoader needs at least one argument");
		System.exit (0);
	    }
	    ScmKernel ker   = new ScmExtendedKernel ();

	    for (int i = 0; i < args.length; i++) {
	      Reader    r      = new FileReader (args [i]);
	      ScmParser parser = new ScmParser (r);
	    
	      long      time1 = System.currentTimeMillis();
	      
	      ScmObject obj  = parser.read ();
	
	      while (obj != null) {
		ker.eval (obj);
		obj = parser.read();
	      }   

	      long time2 = System.currentTimeMillis();
	      System.out.println (args[i]+" loaded in "+(time2-time1)+" ms");
	    }  
	} catch (ScmException e) {
	    System.out.println (e);
	}
    }
}
