#!/usr/bin/ruby

module PageGenerator
  def generate_page
    template = ERB.new File.read('templates/index.html.erb')
    html = template.result(binding)
    File.write("templates/#{file_name}", html)
  end

  private

  def file_name
    self.class.to_s.downcase + '.html'
  end

  def site_name
    self.class
  end

  def footer
    str = <<~FOOTER
    <footer>
      <h5>More jobs at:</h5>
      <a href="./gorails.html">From GoRails</a><br>
      <a href="./weworkremotely.html">From WeWorkRemotely</a><br>
      <a href="./rubyonrailsjobs.html">From RubyOnRailsJobs</a><br>
      <a href="./rubyonremote.html">From RubyOnRemote</a><br>
    </footer>
    FOOTER
    str.sub(/.*#{site_name}.*/, "")
  end
end
