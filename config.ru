require 'prawn'

class Certification

  attr_accessor :name, :title, :reason

  def initialize(name, title, reason)
    self.name = name
    self.title = title
    self.reason = reason
  end

  def to_pdf
    Prawn::Document.new :page_size => "A5", :page_layout => :landscape,
      :top_margin => 10, :left_margin => 10, :bottom_margin => 10, :right_margin => 10 do |pdf|
      pdf.rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height
      pdf.fill_color = "fae9ad"
      pdf.stroke_color = "806c27"
      pdf.line_width = 5
      pdf.fill_and_stroke
      pdf.fill_color = "433400"
      pdf.font "OldLondon.ttf"
      pdf.move_down 20
      pdf.text "Certification", :align => :center, :size => 70
      pdf.move_down 50
      pdf.font "centabel.ttf"
      pdf.text "This certifies that", :align => :center, :size => 20
      pdf.move_down 10
      pdf.font "jphsl.ttf"
      pdf.text name, :align => :center, :size => 40
      pdf.move_down 10
      pdf.font "centabel.ttf"
      pdf.text "has been certified as a", :align => :center, :size => 20
      pdf.move_down 10
      pdf.font "Helvetica"
      pdf.text title, :align => :center, :size => 30
      pdf.font "centabel.ttf"
      pdf.text "by the Rails Certification Team for", :align => :center, :size => 15
      pdf.move_down 15
      pdf.font "Helvetica"
      pdf.text reason, :align => :center, :size => 20
      pdf.image "ribbon.png", :at => [30, 300], :scale => 0.4
    end.render
  end

  def call
    pdf = to_pdf
    [200, {"Content-Type" => "application/pdf", "Content-Length" => pdf.size.to_s}, pdf]
  end


  def self.call(env)
    req = Rack::Request.new(env)
    name, title, reason = req.params['name'], req.params['title'], req.params['reason']
    if [name, title, reason].all?{|s| s && !s.empty? }
      new(name, title, reason).call
    else
      html = File.read('form.html')
      [200, {"Content-Type" => "text/html", "Content-Length" => html.size.to_s}, html]
    end
  end

end

run Certification
