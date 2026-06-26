# frozen_string_literal: true
#
# Zibby flaky-test-fixer DEMO spec — added to this httparty fork ON PURPOSE.
#
# Self-contained (defines its own class, requires nothing from httparty) so it
# runs standalone with a bare `rspec spec/flaky_demo_spec.rb` — no bundler.
#
# It exercises an UNSEEDED random "network latency": `fetch` raises Timeout when
# rand(100) > TIMEOUT_MS, so the example passes ~66% / fails ~34% across runs →
# CircleCI Insights flags it as FLAKY. The flaky-test-fixer agent should
# stabilize THIS example (stub/seed the randomness) WITHOUT weakening the
# assertion.

class FlakyDemoClient
  TIMEOUT_MS = 65

  class Timeout < StandardError; end

  # The unseeded `rand` below is the root cause of the flake.
  def fetch
    latency_ms = rand(100)
    raise Timeout, "timed out after #{latency_ms}ms" if latency_ms > TIMEOUT_MS

    { status: 'ok', latency_ms: latency_ms }
  end
end

RSpec.describe FlakyDemoClient do
  it 'fetches without timing out' do
    # Stub the unseeded `rand` so latency is always within TIMEOUT_MS (65).
    # Without this, rand(100) > 65 ~34 % of the time → flaky CI failures.
    allow_any_instance_of(FlakyDemoClient).to receive(:rand).with(100).and_return(50)
    expect(FlakyDemoClient.new.fetch[:status]).to eq('ok')
  end
end
