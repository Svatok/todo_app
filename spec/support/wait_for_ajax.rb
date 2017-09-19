# frozen_string_literal: true

module WaitForAjax
  def wait_for_ajax(max_wait_time = 30)
    Timeout.timeout(max_wait_time) do
      sleep 0.1 while pending_ajax_requests?
    end
  end

  def pending_ajax_requests?
    page.evaluate_script("angular.element(document.body).injector().get('$http').pendingRequests.length") > 0
  end
end
