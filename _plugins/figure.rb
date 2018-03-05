class FigureRefTag < Liquid::Tag
  def initialize(tag_name, id, tokens)
    super
    @id = id.strip
  end

  def render(context)
    output = "<a href=\"##{@id}\"></a>"

    return output
  end
end

Liquid::Template.register_tag('figure', FigureRefTag)
Liquid::Template.register_tag('fig', FigureRefTag)