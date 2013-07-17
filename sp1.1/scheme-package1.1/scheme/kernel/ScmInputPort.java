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
 * The Scheme input-port type
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */

public class ScmInputPort extends ScmAtom {
  /** The reader */
  private PushbackReader reader;

  /** The standard input port */
  public final static ScmInputPort STANDARD = new ScmInputPort (System.in);

  /** The current input port */
  public static ScmInputPort current = STANDARD;

  /** 
     * Creates a new input-port
     * @param val The implementing stream
     */
  public ScmInputPort (InputStream val) {
    reader = new PushbackReader (new InputStreamReader (val));
  }

  /** 
     * Creates a new input-port
     * @param val a reader
     */
  public ScmInputPort (Reader val) {
    reader = new PushbackReader (val);
  }

  /** 
     * Creates a new input-port
     * @param val The file name
     */
  public ScmInputPort (String val) throws ScmException {
    try {
      InputStream is = new FileInputStream (val);
      reader         = new PushbackReader (new InputStreamReader (is));
    } catch (IOException ex) {
      error ("IO error: "+ex);
    }
  }

  /**
     * Reads 'reader'
     */
  public Reader getReader() {
    return reader;
  }

  /**
     * Reads a character on the port
     * @return ScmEOF.INSTANCE or a ScmChar
     */
  public ScmObject readChar () throws ScmException {
    try {
      int ch = reader.read();

      if (ch == -1)
	return ScmEOF.INSTANCE;
      else
	return new ScmChar ((char)ch);
    } catch (IOException e) {
      error ("I/O error: "+e);
    }
    return null;
  }

  /**
     * Peeks a character on the port
     * @return ScmEOF.INSTANCE or a ScmChar
     */
  public ScmObject peekChar () throws ScmException {
    try {
      int ch = reader.read();

      if (ch == -1)
	return ScmEOF.INSTANCE;
      else {
	reader.unread (ch);
	return new ScmChar ((char)ch);
      }
    } catch (IOException e) {
      error ("I/O error: "+e);
    }
    return null;
  }

  /**
     * Closes the port
     */
  public void close () throws ScmException {
    if (this != STANDARD)
      try {
      reader.close();
    } catch (IOException e) {
      error ("I/O error: "+e);
    }
  }

  /**
     * Is the port ready?
     */
  public boolean ready () throws ScmException {
    try {
      return reader.ready();
    } catch (IOException e) {
      error ("I/O error: "+e);
    }
    return false;
  }

  /**
     * The external representation of this object
     */
  public String toString () {
    return "#[input-port "+hashCode()+"]";
  }

  /**
     * Equality of two ports
     */
  protected boolean atomEqual (ScmAtom other) {
    return reader.equals (((ScmInputPort)other).reader);
  }
}
