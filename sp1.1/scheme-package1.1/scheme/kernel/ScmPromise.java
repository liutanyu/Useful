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
package scheme.kernel;

/** 
 * Scheme's promise
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */

public class ScmPromise extends ScmObject {
  /** The expression */
  private ScmObject expression;

  /** The environment */
  private ScmStack envs;

  /** The forced value */
  private ScmObject value;

  /** 
     * Create a new promise object
     */
  public ScmPromise (ScmObject exp, ScmStack envs) {
    expression   = exp;
    this.envs    = envs;
    value        = null;
  }

  /**
     * Forces this promise
     */
  public ScmObject force () throws ScmException {
    if (value == null) {
      ScmObject obj = ScmKernel.evalAux2 (expression, envs);
      if (value == null)
	value = obj;
    }
    return value;
  }

  /**
     * @return The external representation of this object
     */
  public String toString () {
    return "#[promise "+hashCode()+"]";
  }

  /**
     * Object structural equality
     *
     * @param      obj - The object to test
     * @return     true if this and obj have the same structure
     */
  public boolean isEqual (ScmObject obj) {
    if (obj instanceof ScmPromise) {
      ScmPromise p = (ScmPromise)obj;
      return (expression.isEqual(p.expression)) &&
	     ((value == null && p.value == null) ||
	      (value != null && p.value != null && value.isEqual(p.value)));
    } else
      return false;
  }
}
