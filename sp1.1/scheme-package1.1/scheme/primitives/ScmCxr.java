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
package scheme.primitives;

import scheme.kernel.*;

/**
 * The Scheme language cxxxxr procedures
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmCxr extends ScmPredefined {
  /**
   * The procedure type
   */
  private String procType;

  /**
   * The instances of this class
   */
  public final static ScmCxr CAAAAR = new ScmCxr ("aaaa");
  public final static ScmCxr CAAADR = new ScmCxr ("aaad");
  public final static ScmCxr CAAAR  = new ScmCxr ("aaa");
  public final static ScmCxr CAADAR = new ScmCxr ("aada");
  public final static ScmCxr CAADDR = new ScmCxr ("aadd");
  public final static ScmCxr CAADR  = new ScmCxr ("aad");
  public final static ScmCxr CAAR   = new ScmCxr ("aa");
  public final static ScmCxr CADAAR = new ScmCxr ("adaa");
  public final static ScmCxr CADADR = new ScmCxr ("adad");
  public final static ScmCxr CADAR  = new ScmCxr ("ada");
  public final static ScmCxr CADDAR = new ScmCxr ("adda");
  public final static ScmCxr CADDDR = new ScmCxr ("addd");
  public final static ScmCxr CADDR  = new ScmCxr ("add");
  public final static ScmCxr CADR   = new ScmCxr ("ad");
  public final static ScmCxr CDAAAR = new ScmCxr ("daaa");
  public final static ScmCxr CDAADR = new ScmCxr ("daad");
  public final static ScmCxr CDAAR  = new ScmCxr ("daa");
  public final static ScmCxr CDADAR = new ScmCxr ("dada");
  public final static ScmCxr CDADDR = new ScmCxr ("dadd");
  public final static ScmCxr CDADR  = new ScmCxr ("dad");
  public final static ScmCxr CDAR   = new ScmCxr ("da");
  public final static ScmCxr CDDAAR = new ScmCxr ("ddaa");
  public final static ScmCxr CDDADR = new ScmCxr ("ddad");
  public final static ScmCxr CDDAR  = new ScmCxr ("dda");
  public final static ScmCxr CDDDAR = new ScmCxr ("ddda");
  public final static ScmCxr CDDDDR = new ScmCxr ("dddd");
  public final static ScmCxr CDDDR  = new ScmCxr ("ddd");
  public final static ScmCxr CDDR   = new ScmCxr ("dd");

  /**
   * The constructor
   * @param proc specify the type of car and cdr composition
   */
  protected ScmCxr (String proc) {
    procType = proc;
  }

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 1)
      error ("1 argument expected");

    ScmObject result = args.get(0);

    for (int i = procType.length()-1; i >= 0; i--) {
      if ((result instanceof ScmPair) && result != ScmPair.NULL)
	if (procType.charAt(i) == 'a')
	  result = ((ScmPair)result).getCar();
	else
	  result = ((ScmPair)result).getCdr();
      else
	error ("Pair expected: "+result);
    }

    return result;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive c"+procType+"r]";
  }
}
