load "raggle" # require './raggle' doesn't work :(
require 'test/unit'


class TestEachElement < Test::Unit::TestCase
  def check_stream(source, tokens)
    Raggle::HTML::Parser::each_token(source) do |type, data, attributes|
      assert !tokens.empty?, "too many tokens found. type: #{type} data: \"#{data}\""
      token = tokens.shift
      assert_equal token[0], type, "type"
      assert_equal token[1], data, "data"
      assert_equal token[2] || {}, attributes, "attributes"
    end
    assert tokens.empty?, "all tokens found: #{tokens.inspect}"
  end
  
  def test_just_text
    check_stream "foo", [[:TEXT, "foo"]]
  end

  def test_multiple_lines_of_text_is_just_one_text_token
    check_stream "foo\nbar\nbaz\n", [[:TEXT, "foo\nbar\nbaz\n"]]
  end
  
  def test_one_start_tag
    check_stream "<foo>", [[:START_TAG, "foo"]]
  end
  
  def test_two_start_tags
    check_stream "<foo><bar>", [[:START_TAG, "foo"], [:START_TAG, "bar"]]
  end
  
  def test_start_tags_and_text
    check_stream "<foo>bar<baz>",
      [[:START_TAG, "foo"],
      [:TEXT, "bar"],
      [:START_TAG, "baz"]]
  end
  
  def test_one_end_tag
    check_stream "</foo>", [[:END_TAG, "foo"]]
  end
  
  def test_two_end_tags
    check_stream "</foo></bar>", [[:END_TAG, "foo"], [:END_TAG, "bar"]]
  end
  
  def test_start_and_end_tags
    check_stream "<foo><bar></bar></foo>",
      [[:START_TAG, "foo"],
      [:START_TAG, "bar"],
      [:END_TAG, "bar"],
      [:END_TAG, "foo"]]
    
    check_stream "<foo></foo><bar></bar>",
      [[:START_TAG, "foo"],
      [:END_TAG, "foo"],
      [:START_TAG, "bar"],
      [:END_TAG, "bar"]]
  end
  
  def test_text_and_tags
    check_stream "<foo>bar</foo>",
      [[:START_TAG, "foo"],
      [:TEXT, "bar"],
      [:END_TAG, "foo"]]
    
    check_stream "<foo>a<bar>b</bar>c</foo>",
      [[:START_TAG, "foo"],
      [:TEXT, "a"],
      [:START_TAG, "bar"],
      [:TEXT, "b"],
      [:END_TAG, "bar"],
      [:TEXT, "c"],
      [:END_TAG, "foo"]]
  end
  
  def test_tag_with_attributes
    check_stream "<foo bar='baz'>", [[:START_TAG, "foo", {'bar' => 'baz'}]]
    check_stream "<foo bar='baz'>abc", [[:START_TAG, "foo", {'bar' => 'baz'}], [:TEXT, "abc"]]
  end

  def test_attributes_dont_need_values
    check_stream '<foo bar>', [[:START_TAG, 'foo', {'bar' => ''}]]
  end

  def test_attributes_can_use_single_and_double_quotes
    check_stream '<foo bar="baz">', [[:START_TAG, 'foo', {'bar' => 'baz'}]]
    check_stream "<foo bar='baz'>", [[:START_TAG, 'foo', {'bar' => 'baz'}]]
    check_stream "<foo bar=\"baz'>", [[:START_TAG, 'foo', {'bar' => 'baz'}]] # XXX
  end

  def test_attributes_value_doesnt_need_to_be_quoted
    check_stream '<foo bar=baz>', [[:START_TAG, 'foo', {'bar' => 'baz'}]]
  end

  def test_different_kinds_of_attributes_can_be_combined
    check_stream "<foo bar='baz' quux xyzzy=\"foo\" kala=kukko>",
      [[:START_TAG, 'foo', {'bar' => 'baz', 'quux' => '', 'xyzzy' => 'foo', 'kala' => 'kukko'}]]
  end

  def test_tag_can_span_multiple_lines
    check_stream "<foo \nbar=baz>", [[:START_TAG, 'foo', {'bar' => 'baz'}]]
    check_stream "<kala\nbar\n=\nbaz\n>", [[:START_TAG, 'kala', {'bar' => 'baz'}]]
  end

  def test_incomplete_tags_are_not_skipped_if_tag_has_attributes
    # incomplete tags are skipped
    block_was_run = false
    Raggle::HTML::Parser::each_token "<fooba" do |type, data|
      block_was_run = true
    end
    assert block_was_run, "incomplete tags should be skipped"
    
    block_was_run = false
    Raggle::HTML::Parser::each_token "<foobar baz='quux'" do |type, data|
      block_was_run = true
    end
    assert block_was_run, "incomplete tags aren't skipped if the tag has attributes"
  end
end

class TestRenderer < Test::Unit::TestCase
  def test_simple_text
    assert_equal "foo\n", render("foo")
    assert_equal "foo bar\n", render("foo\nbar"), "on default, newlines are ignored"
  end
  
  def test_too_long_lines_are_wrapped
    lines = render("a"*70 + "\nabcdef\n").split("\n")
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "abcdef", lines[1], "second line"
  end
  
  def test_split_at_word_boundary
    lines = render("a"*70 + " abcdef").split("\n")
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "abcdef", lines[1], "second line"
  end
  
  def test_split_at_word_and_line_boundary
    lines = render("a"*70 + "\n" + "a" * 70 + " abcdef").split("\n")
    assert_equal 3, lines.size, "three lines"
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "a"*70, lines[1], "second line"
    assert_equal "abcdef", lines[2], "third line"
  end
  
  def test_unknown_tags_insert_one_space
    assert_equal "abc def\n", render("<foo>abc</foo><bar>def</bar>"), "unknown tags are skipped"
  end
  
  def test_unknown_tags_shouldn_insert_two_consecutive_spaces
    assert_equal "abc def\n", render("abc<foo><bar>def"), "unknown tags are skipped"
  end
  
  def test_unknown_tags_dont_interfere_with_reflow
    lines = render("a" * 70 + "<footag>" + "b" * 70).split("\n")
    assert_equal 2, lines.size, "two lines"
    assert_equal "a" * 70, lines[0], "first line"
    assert_equal "b" * 70, lines[1], "second line"
  end
  
  def test_p_tag
    assert_equal "foo\n\nbar\n\n", render("<p>foo</p><p>bar</p>"), "</p> adds \\n"
  end
  
  def test_br_tag
    assert_equal "a\nb\nc\n", render("a<br/>b<br/>c<br/>"), "<br/> forces linebreak"
    assert_equal "a\nb\nc\n", render("a<br>b<br>c<br>"), "<br> is recognized too"
  end
  
  def test_pre_tag
    assert_equal "a\nb \n\n", render("<pre>a\nb \n</pre>"), "<pre> just dumps the text"
    assert_equal "a\nb \n\nc\n", render("<pre>a\nb </pre>c"), "newline is added unless it is already there"
  end
  
  def test_width_affects_line_wrapping
    lines = render(("a" * 30 + " ") * 3, 40).split("\n")
    assert_equal 3, lines.size, "3 lines"
  end
end

class TestRenderer < Test::Unit::TestCase
  def render(text, width=72)
    Raggle::HTML::render_html(text, width)
  end
  
  def test_untagged_text_is_rendered_like_text_inside_p
    assert_equal "foo\n", render("foo")
    assert_equal "foo bar\n", render("foo\nbar"), "on default, newlines are ignored"
  end
  
  def test_too_long_lines_are_wrapped
    lines = render("a"*70 + "\nabcdef\n").split("\n")
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "abcdef", lines[1], "second line"
  end
  
  def test_split_at_word_boundary
    lines = render("a"*70 + " abcdef").split("\n")
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "abcdef", lines[1], "second line"
  end
  
  def test_split_at_word_and_line_boundary
    lines = render("a"*70 + "\n" + "a" * 70 + " abcdef").split("\n")
    assert_equal 3, lines.size, "three lines"
    assert_equal "a"*70, lines[0], "first line"
    assert_equal "a"*70, lines[1], "second line"
    assert_equal "abcdef", lines[2], "third line"
  end
  
  def test_unknown_tags_insert_one_space
    assert_equal "abc def\n", render("<foo>abc</foo><bar>def</bar>"), "unknown tags are skipped"
  end
  
  def test_unknown_tags_shouldn_insert_two_consecutive_spaces
    assert_equal "abc def\n", render("abc<foo><bar>def"), "unknown tags are skipped"
  end
  
  def test_unknown_tags_dont_interfere_with_reflow
    lines = render("a" * 70 + "<footag>" + "b" * 70).split("\n")
    assert_equal 2, lines.size, "two lines"
    assert_equal "a" * 70, lines[0], "first line"
    assert_equal "b" * 70, lines[1], "second line"
  end
  
  def test_tags_are_case_insentive
    assert_equal render("<P>foo bar<BR></P>"), render("<p>foo bar<br></p>"), "tags are case insensitive"
  end
  
  def test_p_tag
    assert_equal "foo\n\nbar\n", render("<p>foo</p><p>bar</p>"), "</p> adds \\n. But not at the end of text"
  end
  
  def test_two_consecutive_p_tags_newline_in_the_middle
    assert_equal "foo\n\nbar\n", render("<p>foo</p>\n<p>bar</p>"), "<p>\n<p>"
  end
  
  def test_p_untagged_text_p_equals_three_paragraphs
    assert_equal "foo\n\nbar\n\nbaz\n", render("<p>foo</p>bar<p>baz</p>")
  end
  
  def test_p_after_normal_text_adds_empty_line
    assert_equal "foo bar\n\nfoo\n", render("foo bar<p>foo</p>"), "<p> after normal text"
  end
  
  def test_br_tag
    assert_equal "a\nb\nc\n", render("a<br/>b<br/>c<br/>"), "<br/> forces linebreak"
    assert_equal "a\nb\nc\n", render("a<br>b<br>c<br>"), "<br> is recognized too"
  end
  
  def test_pre_tag
    assert_equal "a\nb \n", render("<pre>a\nb \n</pre>"), "<pre> just dumps the text"
    assert_equal "a\nb \n\nc\n", render("<pre>a\nb </pre>c"), "newline is added unless it is already there"
  end
  
  def test_pre_after_normal_text_adds_empty_line
    assert_equal "foo bar\n\nfoo\n", render("foo bar<pre>foo</pre>"), "<pre> after normal text"
  end

  def test_links_are_rendered_offline
    assert_equal "foo bar[1] baz\n\nLinks:\n1. http://example.com\n", render("<p>foo <a href=\"http://example.com\">bar</a> baz</p>")
  end

  def test_link_references_are_reused
    assert_equal "foo bar[1] baz[2] quux[1]\n\nLinks:\n1. http://example.com\n2. http://other.example.com\n",
      render('<p>foo <a href="http://example.com">bar</a> <a href="http://other.example.com">baz</a> ' +
             '<a href="http://example.com">quux</a>')
  end
  
  def test_link_references_are_aligned_automagically
    text = ''
    10.times { |i| text << "<a href='http://example.com/#{i}'>Link #{i}" }
    lines = render(text)
    # if there are more than 9 links, then link refs < 10 are padded with one space
    assert_match %r{^ 1. http://example.com/0$}, lines, 'references are padded'
    assert_match %r{^10. http://example.com/9$}, lines, 'no padding needed'
  end

  def test_links_shouldnt_add_newlines_inside_pre
    expexted =
      "\n" + 
      "17:32 <bma[1]> http://tynian.net/grill.jpg[2]\n" +
      "\n" +
      "Links:\n" +
      "1. http://tynian.net/\n" +
      "2. http://tynian.net/grill.jpg\n"
    html = "<pre>\n" +
      "17:32 &lt;<a href='http://tynian.net/'>bma</a>&gt; <a href='http://tynian.net/grill.jpg'>http://tynian.net/grill.jpg</a>\n" +
      "</pre>\n"
      
    assert_equal expexted, render(html)
  end

  def test_h1_behaves_like_p
    assert_equal "foo bar\n\nb\n", render("<h1>foo bar</h1>b"), "H1"
  end

  def test_h2_behaves_like_
    assert_equal "foo bar\n\nb\n", render("<h2>foo bar</h2>b"), "H2"
  end

  def test_h3_behaves_like_p
    assert_equal "foo bar\n\nb\n", render("<h3>foo bar</h3>b"), "H3"
  end

  def test_h4_behaves_like_p
    assert_equal "foo bar\n\nb\n", render("<h4>foo bar</h4>b"), "H4"
  end

  def test_h5_behaves_like_p
    assert_equal "foo bar\n\nb\n", render("<h5>foo bar</h5>b"), "H5"
  end

  def test_h6_behaves_like_p
    assert_equal "foo bar\n\nb\n", render("<h6>foo bar</h6>b"), "H6"
  end

  def test_width_affects_line_wrapping
    lines = render(("a" * 30 + " ") * 3, 40).split("\n")
    assert_equal 3, lines.size, "3 lines"
  end
end

class TestTagSet < Test::Unit::TestCase
  def test_define_tag
    tags = Raggle::HTML::TagSet.new do |tag_set|
      tag_set.define_tag 'foo' do |tag|
      end
    end

    assert tags['foo'] != nil, 'tag foo defined'
  end

  def test_define_multiple_identical_tags
    tags = Raggle::HTML::TagSet.new do |tag_set|
      tag_set.define_tag 'foo', 'bar' do |tag|
      end
    end

    assert tags['foo'] != nil, 'tag foo defined'
    assert tags['bar'] != nil, 'tag bar defined'
    assert_same tags['foo'], tags['bar'], 'tag foo and bar are identical (same)'
  end

  def test_define_context
    tags = Raggle::HTML::TagSet.new do |tag_set|
      tag_set.define_tag 'foo' do |tag|
	tag.context = :in_foo
      end

      tag_set.define_tag 'bar' do |tag|
      end
    end

    assert_equal :in_foo,  tags['foo'].context, 'context defined'
    assert_equal nil, tags['bar'].context, 'on default context is nil'
  end

  def test_defining_actions
    tags = Raggle::HTML::TagSet.new do |tag_set|
      tag_set.define_tag 'actions' do |tag|
	tag.start_actions = :a, :b
	tag.end_actions = :c, :d
      end

      tag_set.define_tag 'no_actions' do |tag|
      end
    end

    assert_equal [:a, :b], tags['actions'].start_actions, 'start actions'
    assert_equal [:c, :d], tags['actions'].end_actions, 'end actions'
    assert_equal [], tags['no_actions'].start_actions, 'on default action list is empty'
    assert_equal [], tags['no_actions'].end_actions, 'on default actions list is empty'
  end

  def test_defined?
    tags = Raggle::HTML::TagSet.new do |tag_set|
      tag_set.define_tag 'foo' do |tag|
      end
    end

    assert tags.defined?('foo'), 'foo tag defined'
    assert !tags.defined?('bar'), 'bar tag isnt defined'
  end
end

