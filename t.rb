#!/bin/ruby
require 'logger'
logger = Logger.new("./hook_post_receive.log")

message = `git push gitlabcom 2>&1`

result = $?

unless 0.eql? result.exitstatus
    logger.error "#{result.exitstatus} - #{message}"
end
