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

import java.io.*;

/** 
 * The Scheme output-port type
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/26
 */

public class ScmOutputPort extends ScmAtom {
  /** The writer */
  private Writer value;

  /** The standard output port */
  public final static ScmOutputPort STANDARD = new ScmOutputPort (System.out);

  /** The current output port */
  public static ScmOutputPort current = STANDARD;

  /** 
   * Creates a new output-port
   * @param val The implementing stream
   */
  public ScmOutputPort (OutputStream val) {
    value = new OutputStreamWriter (val);
  }

  /** 
   * Creates a new output-port
   * @param val a writer
   */
  public ScmOutputPort (Writer val) {
    value = val;
  }

  /** 
   * Creates a new output-port
   * @param val The file name
   */
  public ScmOutputPort (String val) throws ScmException {
    try {
      value = new OutputStreamWriter (new FileOutputStream (val));
    } catch (IOException ex) {
      error ("IO error: "+ex);
    }
  }

  /**
   * Returns the implementing writer
   */
  public Writer getValue () {
    return value;
  }

  /**
   * Reads the string if this is a string port
   */
  public String getString () throws ScmException {
    if (!(value instanceof StringWriter))
      error ("must be an output-string-port");

    return ((StringWriter)value).toString();
  }

  /**
   * Tests if the port is a string-port
   * @return true if value is a StringWriter
   */
  public boolean isString () {
    return (value instanceof StringWriter);
  }

  /**
   * Writes a string on the port
   * @param str The string to write
   */
  public void write (String str) throws ScmException {
    try {
      for (int i = 0; i < str.length(); i++)
	value.write (str.charAt(i));
      value.flush();
    } catch (IOException e) {
      error ("I/O error");
    }
  }

  /**
   * Closes the port
   */
  public void close () throws ScmException {
    if (this != STANDARD)
      try {
	value.close();
      } catch (IOException e) {
	error ("I/O error");
      }
  }

  /**
   * External representation
   */
  public String toString () {
    return "#[output-port "+hashCode()+"]";
  }

  /**
   * Equality of ports
   */
  protected boolean atomEqual (ScmAtom other) {
    return value.equals (((ScmOutputPort)other).value);
  }
}
