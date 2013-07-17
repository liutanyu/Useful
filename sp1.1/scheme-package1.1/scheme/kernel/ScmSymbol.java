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
 * A scheme language symbol
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmSymbol extends ScmAtom {
  
  // Private fields
  //
  protected String string;

  /**
   * `else' keyword
   */
  public static final ScmSymbol ELSE = new ScmSymbol ("else");
  
  /**
   * `quote' keyword
   */
  public static final ScmSymbol QUOTE = new ScmSymbol ("quote");
  

  /**
   * `unquote' keyword
   */
  public static final ScmSymbol UNQUOTE = new ScmSymbol ("unquote");
  

  /**
   * `quasiquote' keyword
   */
  public static final ScmSymbol QUASIQUOTE = new ScmSymbol("quasiquote");
  

  /**
   * `unquote-splicing' keyword
   */
  public static final ScmSymbol UNQUOTE_SPLICING = new ScmSymbol ("unquote-splicing");  

  /**
   * `=>' keyword
   */
  public static final ScmSymbol IMPLIES = new ScmSymbol ("=>");  

  /**
   * Create a new symbol represented by str
   * @param str - The representation of this symbol
   * @require str != null
   */
  public ScmSymbol (String str) {
    string = str.toLowerCase();
  }

  /**
   * Create a new symbol represented by str
   * @param str - The representation of this symbol
   * @require str != null
   */
  public ScmSymbol (ScmString str) {
    string = new String(str.getValue());
  }

  /**
   * @return The external representation of this object
   */
  public String toString () {
    return string;
  }

  /**
   * @return this symbol hash code
   */
  public int hashCode ()
  {
    return string.hashCode();
  }

  /**
   * @param obj - the reference object with which to compare.
   * @return true if this object is the same as obj
   */
  public boolean equals (Object obj) {
    return (obj instanceof ScmSymbol) && string.equals (((ScmSymbol)obj).string);
  }

  /**
   * @param  other - The other atom to test
   * @return true if this equals other
   */
  protected boolean atomEqual (ScmAtom other) {
    return string.equals (((ScmSymbol)other).string);
  }
}
