require 'minitest/autorun'
require 'benchmark'
require 'rest_client'
require 'json'
require_relative '../JackHELP.rb'

# Want to run a single test?
# You probably do when developing.
# ruby test_JackSON.rb --name test_AAA_post

class TestJackSON < Minitest::Test
  
  # Big bold HTTP method constants.
  # Better reminders?
  POST = 'POST'
  GET = 'GET'
  PUT = 'PUT'
  DELETE = 'DELETE'
  
  def self.test_order
    :alpha
  end
  
  # The actual tests!
  
  # Create a brand new JSON file
  def test_AAA_post
    r = api( POST, 'test/data', 'json/foo_bar' )
    assert( success?(r), true )
  end
  
  # Can't POST if JSON file exists at url
  def test_AAB_post_dupe
    begin
      api( POST, 'test/data', 'json/foo_blank' )
    rescue
      assert( 1, 1 )
    end
    assert( 1, 0 )
  end
  
  # PUT will change an existing JSON file
  def test_AAC_put
    r = api( PUT, 'test/data', 'json/foo_blank' )
    assert( success?(r), true )
  end
  
  # What you retrieve and what you start with should be the same
  def test_AAD_get
    check = false;
    r = api( GET, 'test/data' )
    j = hashit('json/foo_blank')
    if j == r
      check = true;
    end
    assert( check, true )
  end
  
  def test_AAE_delete
    api( DELETE, url('test/data') )
    assert( 1, 1 )
  end
  
  # Helper methods.
  private 
  
  def url( rel )
    "http://localhost:4567/data/#{rel}"
  end
  
  def hashit( file )
    return {} if file ==nil
    file = JackHELP.run.json_file( File.dirname(__FILE__), file )
    JSON.parse( File.read( file ) )
  end
  
  def hashttp( file )
    { :data => hashit( file ) }
  end
  
  def api( method, path, file=nil )
    r = nil
    path = url( path )
    file = hashttp( file )
    case method.upcase
    when POST
      r = RestClient.post path, file
    when PUT
      r = RestClient.put path, file
    when GET
      r = RestClient.get path
    when DELETE
      r = RestClient.delete path, file
    end
    JSON.parse( r )
  end
  
  def success?( hash )
    hash.include?("success")
  end
  
end
