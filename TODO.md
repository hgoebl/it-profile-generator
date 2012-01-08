# it-profile-generator

Generates a CV/Resume (in Germany usually called 'profile') for an IT freelancer.

A Mobile Web Application can display the data of the profile / CV.

## TODO

  * Provide a How-to (editing, features, photos, language support, hosting, ...)
  * Make index.multilang.html work again to simplify testing (w/o generating-step)
  * More comfortable use of single-language profiles (extract language from profile)
  * Minimize JavaScript and CSS; Reduce number of roundtrips for jQuery Mobile application
  * Further development of Sencha Touch application
  * Deal with bigger display viewports like iPad
  * SEO: Add meta-data in HTML-header and PDF (like language, keywords, summary, ...)
  * Refactor XML-structure; provide XSLT script for translating to new version.
  * add availability
  * add privacy attribute (e.g. for E-Mail address, telephone number, ...)
  * handle missing tags gracefully
  * Test with non-httpd Web-Server (do they behave like mod_negotiation?)
  * Provide .cmd files for Microsoft Windows
  * Test/adopt for Cygwin
  * use ant instead of bash scripts?
  * create target directory, copy profiles/... to target; generate to target dir
  * generate index.html page for overview (and download_...php links for Word/PDF/...)
  * generate .odt files (or .doc with [Apache POI](http://poi.apache.org/))
  * deal with "a" tag (apply-templates) in project descriptions (don't forget JSON)
  * change xml-parsing to xml2js instead of poor-xml2json.
  * implement Tests with mocha and should
  * implement Selenium / Soda tests for the jQuery Mobile implementation.
  * generate QR-Code images out of web addresses
  * generate *.gz files (for efficient delivery for content-encoding gzip)

## Known Bugs

  * Editing contact form in landscape orientation; Keyboard and header/footer hides edit fields almost completely
  * Single-language generation always uses 'en'
  * contact.php must be edited after deployment: uses fixed email addresses
