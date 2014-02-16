# it-profile-generator

Generates a CV/Resume (in Germany usually called 'profile') for an IT freelancer.

A Mobile Web Application can display the data of the profile / CV.

## Why?

Freelancers have to provide detailed profiles of their knowledge and work experience when they want to apply for a
job or a project.

Unfortunately the companies demand for profiles in different formats and languages. Maintaining such a profile is
tedious work.

This collection of scripts convert a single XML file of input into different output documents.

## Supported Formats

  * HTML (Classic Version 4 for Desktop Browsers - sorry for formatting with `<table>`)
  * html5 (a [jQuery Mobile](http://jquerymobile.com/) Smartphone/Tablet touch-enabled application)
  * PDF
  * TXT (useful for some IT-profile hosting providers, especially for the list of projects / work experience)
  * JSON (to be used by Smartphone applications)
  * vCard
  * PNG (QR-Code of vCard)

Hopefully coming soon (you can contribute!):

  * DOC (MS-Word 97/2003)

    If you need your resume in Word format, open the HTML page with Internet Explorer, select all (`<Ctrl>+A`)
    and paste it into a new Word document (`<Ctrl>+V`). This will produce a quite suitable document.
    I've tested this with Word 2010, Windows 7, IE 9. Other Versions might crash or produce horrible output ;-)
  * ODT (Open Document Text, readable by new MS-Word and OpenOffice/LibreOffice)
  * html5 (a [Sencha Touch](http://www.sencha.com/products/touch/) Smartphone/Tablet touch-enabled application)

## Example Output

  * Output: <http://www.goebl.com/profiles/hgoebl/>
  * Mobile App: <http://m.goebl.com/> (will redirect to <http://www.goebl.com/m/jqm/?hgoebl>)

The Mobile App should not work with old or trouble-making browsers (you know what I M$ean).

## Getting Started

**By now the generator is only tested under Linux and Windows/Cygwin.
Native Windows support should'nt be a problem for a DOS-Command-Scripter ;-).
iOS will not be supported by me, unless Apple is sponsering an iMac to me - help needed!**

  * Java Runtime Environment must be installed (1.6 recommended)
  * Download [Apache FOP](http://xmlgraphics.apache.org/fop/).
    Alternatively you can use the packaged version from your Linux distribution, e.g.

        sudo apt-get install fop
    I've tested with 0.95 and 1.0. Don't know why, but I'd prefer 1.0.
  * Download and install [Node.js](http://nodejs.org/)
    I've tested with 0.4.x so far, 0.6.x should work well; Tell me, if not!
  * //Optional: Download/install qrencode

        sudo apt-get install qrencode

  * Windows Users can use <http://code.google.com/p/qrencode-win32/>, the executable name is `qrcode.exe`

  * Clone this project (of course you can fork it) and change to its directory
  * Copy the example setenv script and adopt it to your installation.
    If fop and node is in your PATH, just set NODE=node and FOP=fop.
    If not, you have to find out the location of the programs.

        cp setenv-example.sh setenv.sh
        chmod u+x setenv.sh
        # edit the freshly created setenv.sh
        $EDITOR setenv.sh

  * Download and install Node module dependenies
    (Windows/Cygwin-Users: run `npm` in a DOS-Shell. It is said that npm sometimes hangs in Cygwin shell.)

        cd node-app
        npm install
        cd ..

First an initial generation script has to be executed (like make but w/o make):

    ./generate-i18n.sh

Now you should be able to run the generator script:

    ./generate.sh sample-multilang

or (much longer)

    ./generate.sh hgoebl

Warnings like the following can be ignored (come from .rtf generation where the number of pages cannot be computed):

<pre>
    Jan 3, 2012 10:31:42 AM org.apache.fop.events.LoggingEventListener processEvent
    WARNING: Ignored deferred event for org.apache.fop.fo.flow.PageNumberCitationLast@2b12e7f7[@id=] (start). (See position 1:1945)
</pre>

After the generation of different output formats and languages works with your environment, you can create your own
profile.

  * Choose a name for your new profile (should obey `/[A-Za-z0-9-_]/`, dot is not ideal and could cause
    trouble, spaces and non-ASCII characters are evil).
    For this example, lets assume you chose `michaelj` as your name.

  * Choose whether you want to create a profile in different languages or only one language.
    It's not very complicated to switch from single to multi or vice versa. To he honest, it's easier to switch
    from multi to single, so in case of doubt begin with the multi-language profile.

### Multi-Language Profiles

  * Call the create script for multiple languages:

        ./create-profile-multilang.sh michaelj

  * Change to the new directory and edit your profile:

        cd profiles/michaelj

  * Edit the profile with your favorite XML editor. If desired, I can provide a XSD for it.

        $EDITOR michaelj.multilang.xml

  * Adopt the languages you want to support (each line contains a simple language code, like 'en', 'de', 'nl', 'fr').
    Don't append empty lines or spaces before or after the language code, this could lead to unexpected results.

        $EDITOR supported-languages.txt

### Single-Language Profiles

  * Call the create script for only one language:

        ./create-profile-singlelang.sh michaelj

  * Change to the new directory and edit your profile:

        cd profiles/michaelj

  * Edit the profile with your favorite XML editor. If desired, I can provide a XSD for it.

        $EDITOR michaelj.xml

### Generating Output

  * Generate your profile (it can cause problems if you have Acrobat Reader open while re-generating a PDF)

        ./generate.sh michaelj

  * You should find generated files in the profiles/michaelj folder.

## License

See MIT-LICENSE.txt.

## Contributing

I'd appreciate your contribution. I'm afraid especially the translation to English is far below optimum.
If you're not so familiar with Github/git, you can send mails to me (my mail address is in profiles/hgoebl/hgoebl.multilang.xml).

The easiest way to help is by reporting bugs and/or mail whishes. Don't hesitate!

## Add Support for Additional Languages

Edit `xslt/i18n.xml` and create entries for the new language.

If the format of the postal address differs from `{{city}} {{zip}}`, you should edit `xslt/i18n-support.xsl`
and add the format for your language. (Of course language is not equal to country, so selecting the postal format upon
the language is not the most clever solution.)

After that the script `./generate-i18n.sh` must be executed.
If translations for keys are missing, the key will be used instead of the value.

I would be happy if you shared your work with us!
If you don't want to clone/fork/... send me the file by mail.

## TODO and Known Bugs

See TODO.md

## Credits

Thanks for your help:

  * Thomas Siedschlag (Testing/Adaption to Windows/Cygwin, improvements in XSLT scripts)

This is only a collection of software used:

  * [jQuery Mobile](http://jquerymobile.com/)
  * [jQuery - write less, do more](http://jquery.com/)
  * [Debian GNU/Linux](http://www.debian.org/)
  * [The Apache Software Foundation](http://www.apache.org/)
  * [Node.js](http://nodejs.org/)
  * [Mustache - Logic-less templates](http://mustache.github.com/)
  * [FAMFAMFAM icons by Mark James](http://www.famfamfam.com/)
  * Modules for Node: async, optimist, sax, underscore, wordwrap, xml2js
