# frozen_string_literal: true
require 'workflow'
Workflow.config do |config|
  config.persist_workflow_state_immediately = false
end
