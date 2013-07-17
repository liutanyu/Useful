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
import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

import scheme.kernel.*;
import scheme.extensions.*;

/**
 * Scheme Applet
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/24
 */
public class ScmApplet extends Applet {
    private TextArea  input;
    private TextArea  output;
    private Panel     textPanel;
    private Panel     buttons;
    private Button    eval;
    private Button    clear;

    private ScmKernel kernel;

    /**
     * Initialize the applet
     */
    public void init () {
	setLayout (new BorderLayout());

	textPanel = new Panel ();
	textPanel.setLayout (new BorderLayout());

	add (BorderLayout.CENTER, textPanel);

	input = new TextArea ();
	textPanel.add (BorderLayout.CENTER, input);

	output = new TextArea ();
	output.setEditable (false);
	textPanel.add (BorderLayout.SOUTH, output);

	buttons = new Panel();
	buttons.setLayout (new FlowLayout());
	add (BorderLayout.WEST, buttons);
	
	eval = new Button ("Eval");
	eval.addActionListener (new EvalAction ());
	buttons.add (eval);

	clear = new Button ("Clear");
	clear.addActionListener (new ClearAction ());
	buttons.add (clear);

	kernel = new ScmExtendedKernel ();
    }

  /**
   * Eval action
   */
  class EvalAction implements ActionListener {

    public void actionPerformed(ActionEvent e) {
	String str = input.getText();
	Reader r = new StringReader (str);
	input.setText ("");

	try {
	    output.append (str+"=>\n");
	    ScmParser par = new ScmParser (r);
	    ScmObject obj = par.read();

	    while (obj != null) {
		output.append (kernel.eval (obj)+"\n");
		obj = par.read();
	    }
	} catch (ScmException ex) {
	    output.append ("\n"+ex+"\n");
	}
    }
  }

  /**
   * Clear action
   */
  class ClearAction implements ActionListener {

    public void actionPerformed(ActionEvent e) {
	output.setText ("");
    }
  }
}
