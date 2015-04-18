module SanitizeParams

  protected

  #Use this method instead 'sanitize_params'
  #if you wish get the html content like a
  #simple text
  def escape_params

    request.params.each { |k, v|
      if v.is_a?(String)
        params[k] = CGI.escapeHTML(v)
      elsif v.is_a?(Hash)
        v.each { |nested_key, nested_value|
          params[k][nested_key] = CGI.escapeHTML(nested_value)
        }
      end
    }

  end

  # Check each request parameter for 
  # improper HTML or Script tags
  def sanitize_params
    request.params.each { |k, v|
      if v.is_a?(String)        
        params[k] = sanitize_param v
      elsif v.is_a?(Array)
        params[k] = sanitize_array v
      elsif v.is_a?(Hash)
        v.each { |nested_key, nested_value|
          params[k][nested_key] = sanitize_param nested_value
        }
      end
    }
  end

  # If the parameter was an array, 
  # try to sanitize each element in the array
  def sanitize_array(array)
    array.map! { |e| 
      if e.is_a?(String)
        sanitize_param e
      end
    }
    return array
  end

  # Santitize a single value
  def sanitize_param(value)
    allowed_tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
    ActionController::Base.helpers.sanitize(value, tags: allowed_tags, attributes: %w(href title))
  end

end    
