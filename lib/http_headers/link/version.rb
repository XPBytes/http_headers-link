require 'delegate'

module HttpHeaders
  class Link < DelegateClass(Array)
    VERSION = '0.2.1'
  end
end
