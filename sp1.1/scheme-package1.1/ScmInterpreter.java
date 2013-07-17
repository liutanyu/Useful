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
 * ScmInterpreter
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/25
 */
public class ScmInterpreter {
  private final static String STARTING_MESSAGE =
    "\n  -------------------------------------------------------------------\n"+
      "     S c h e m e  I n t e r p r e t e r  1.0 (C) 1998 - S.Hillion    \n"+
      "  -------------------------------------------------------------------\n";

  private static final String prompt   = "Scheme> ";
  private static final String initFile = "Scheme.scm";

  public static void main (String [] args) {
    try {
      System.out.println (STARTING_MESSAGE);

      ScmKernel ker  = new ScmExtendedKernel ();
      Reader    r;

      Reader    rini   = new StringReader ("(load \""+initFile+"\")");
      ScmParser parser = new ScmParser (rini);
      ScmObject obj    = parser.read ();

      try {
	ker.eval (obj); 
      }
      catch (Exception e) {
	System.out.println (e);
      }

      if (args.length > 0) {
	FileInputStream fis = new FileInputStream (args [0]);
	r = new InputStreamReader (fis);
      }
      else
	r = new InputStreamReader (System.in);

      // Main loop
      //
      System.out.print (prompt);

      ScmParser par = new ScmParser (r);
      obj = par.read ();

      while (obj != null) {
	try {
	  System.out.println (ker.eval (obj));
	}
	catch (ScmException e) {
	  System.out.println (e);
	}

	System.out.print (prompt);
	obj = par.read ();
      }
    }
    catch (Exception e) {
      System.out.println (e);
      e.printStackTrace();
    }
  }
}
