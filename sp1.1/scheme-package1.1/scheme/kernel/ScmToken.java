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
 * A Scheme token
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/24
 */
public class ScmToken {
  // Private members
  //
  private String string;
  private int    type;

  public final static int SYMBOL           = 1;
  public final static int TRUE             = 2;
  public final static int STRING           = 3;
  public final static int LBRA             = 4;
  public final static int RBRA             = 5;
  public final static int QUOTE            = 6;
  public final static int VBRA             = 7;
  public final static int FALSE            = 8;
  public final static int INTEGER          = 9;
  public final static int REAL             = 10;
  public final static int DOT              = 11;
  public final static int CHAR             = 12;
  public final static int QUASIQUOTE       = 13;
  public final static int UNQUOTE          = 14;
  public final static int UNQUOTE_SPLICING = 15;

  /**
   * Predefined lexems
   */
  public final static ScmToken LBra            = new ScmToken (LBRA, "(");
  public final static ScmToken RBra            = new ScmToken (RBRA, ")");
  public final static ScmToken VBra            = new ScmToken (VBRA, "#(");
  public final static ScmToken Quote           = new ScmToken (QUOTE, "'");
  public final static ScmToken Quasiquote      = new ScmToken (QUASIQUOTE, "`");
  public final static ScmToken Unquote         = new ScmToken (UNQUOTE, ",");
  public final static ScmToken UnquoteSplicing = new ScmToken (UNQUOTE_SPLICING, ",@");
  public final static ScmToken Dot             = new ScmToken (DOT, ".");
  public final static ScmToken True            = new ScmToken (TRUE, "#t");
  public final static ScmToken False           = new ScmToken (FALSE, "#f");
  
  /**
   * Create a new token
   */
  public ScmToken (int type, String string) {
    this.type   = type;
    this.string = string;
  }

  /**
   * Reads the value of `type'
   */
  public int getType () {
    return type;
  }

  /**
   * Reads the value of `string'
   */
  public String getString () {
    return string;
  }
}
