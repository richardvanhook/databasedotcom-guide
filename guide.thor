require 'rubygems'
require 'maruku'
require 'rexml/document'

require 'fileutils'

class Guide < Thor
  include FileUtils
  
  SUPPORTED_FORMATS = %w{html latex pdf}
  GUIDE_DIR = File.join(File.dirname(__FILE__), "guide")
  GUIDE_SOURCE_DIR = File.join(File.dirname(__FILE__), "guide-source")
  GUIDE_FILE_NAME = "index"
  OUTPUT_FILE_BASE_NAME = File.join(GUIDE_DIR, GUIDE_FILE_NAME)

  desc "build [FORMAT]", "Build the guide. FORMAT specifies what format the output should have. Defaults to html. Valid options are: #{SUPPORTED_FORMATS.join(", ")}"
  def build(format = 'html')
    doc = Maruku.new(complete_markdown)
    
    if SUPPORTED_FORMATS.include?( format )
      self.send("build_#{format}", doc)
    else
      STDERR << "Error: Don't know how to build for format '#{format}'"
      exit 1
    end
    
  end

  private
  
  
  def build_html(doc)
    File.open(OUTPUT_FILE_BASE_NAME + '.html', 'w+') do |file|
html = <<END_OF_STRING
<!DOCTYPE html>
<html>
<head>
    <title>databasedotcom gem guide</title>
    <link href='css/guide.css' rel='stylesheet' type='text/css' />
    <link href='css/shCore.css' rel='stylesheet' type='text/css' />
    <link href='css/shThemeDefault.css' rel='stylesheet' type='text/css' />
    <script src='js/shCore.js' type='text/javascript'></script>
    <script src='js/shBrushBash.js' type='text/javascript'></script>
    <script src='js/shBrushPlain.js' type='text/javascript'></script>
    <script src='js/shBrushRuby.js' type='text/javascript'></script>
    <script type='text/javascript'>
        SyntaxHighlighter.all();
    </script>
</head>
<body>#{doc.to_html}</body></html>
END_OF_STRING
      file << html
    end
  end
  
  def build_latex(doc)
    File.open(OUTPUT_FILE_BASE_NAME + '.tex', 'w+') do |file|
      file << doc.to_latex_document
    end
  end
  
  def build_pdf(doc)
    build_latex(doc)
    
    Dir.chdir(GUIDE_DIR) do |dir|
      # Run twice to get cross-references right
      2.times { system("pdflatex #{OUTPUT_FILE_BASE_NAME + '.tex'} -output-directory=#{GUIDE_DIR}") }
    
      # Clean up
      file_patterns = %w{*.aux *.out *.toc *.log}
      file_patterns.each do |pattern|
        FileUtils.rm(Dir.glob(pattern))
      end
    end
  end
  
  def complete_markdown
    # Collect all the markdown files in the correct order and squash them together into one big string
    s = [] 
    File.new(GUIDE_SOURCE_DIR + "/guide-order.txt").each_line do |line|
		puts '*** adding ' + line
      line.strip!
      next if line =~ /^#/   # Skip comments
      next if line =~ /^$/   # Skip blank lines

      File.open(File.join(GUIDE_SOURCE_DIR, line)) do |f|
        # I have no idea if the double \n is needed, but seems safe
        s << f.read
      end
    end

    return s.join("\n\n* * *\n\n")
  end

end
