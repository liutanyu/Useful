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
 * The Scheme language 'append' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmAppend extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmAppend INSTANCE = new ScmAppend ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() > 0) {
      ScmObject result = args.get(args.size()-1);

      for (int i = args.size()-2; i >= 0; i--)
	result = append (args.get(i), result);

      return result;
    } else
      return ScmPair.NULL;
  }

  /** 
   * The external representation of the procedure
   */
  public String toString () {
    return "#[primitive append]";
  }

  /**
   * Appends two lists
   */
  private ScmObject append (ScmObject obj1, ScmObject obj2) throws ScmException {
    if (!(obj1 instanceof ScmPair))
      error ("List expected: "+obj1);

    ScmPair   p1  = toPair (obj1);
    ScmPair   p2  = ScmPair.NULL;
    ScmPair   p3;
    ScmObject res = obj2;

    while (p1 != ScmPair.NULL) {
      if (p2 == ScmPair.NULL) {
	p2 = new ScmPair (p1.getCar(), obj2);
	res = p2;
      } else {
	p3 = new ScmPair (p1.getCar(), obj2);
	p2.setCdr (p3);
	p2 = p3;
      }

      p1 = toPair(p1.getCdr());
    }
    return res;
  }
}
