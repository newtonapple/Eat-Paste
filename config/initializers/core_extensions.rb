class String
  unless method_defined?(:shatter)
    
    # From Facets Library
    # Breaks a string up into an array based on a regular expression.
    # Similar to scan, but includes the matches.
    #
    #   s = "<p>This<b>is</b>a test.</p>"
    #   s.shatter( /\<.*?\>/ )
    #
    # _produces_
    #
    #   ["<p>", "This", "<b>", "is", "</b>", "a test.", "</p>"]
    #
    # CREDIT: Trans
    def shatter( re )
      r = self.gsub( re ){ |s| "\1" + s + "\1" }  # trick here is to inject "invisiable" split tokens
      while r[0,1] == "\1" ; r[0] = '' ; end      # remove leading tokens
      while r[-1,1] == "\1" ; r[-1] = '' ; end    # remove trailing tokens
      r.split("\1")                               # now split on invisble token (hence ridding them)
    end
  end
end


class Object
  def in?(arrayish,*more)
    arrayish = more.unshift(arrayish) unless more.empty?
    arrayish.include?(self)
  end
end