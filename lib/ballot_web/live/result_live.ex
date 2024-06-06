defmodule BallotWeb.ResultLive do
  require Logger
  use BallotWeb, :live_view
  alias Ballot.Poll

  def mount(%{"vote_id" => vote_id}, _session, socket) do
    Poll.start_vote(vote_id)
    socket = render_result(vote_id, socket)|> assign(:vote_id, vote_id)
    Poll.add_result_board(vote_id, self())
    {:ok, socket}
  end
  def handle_info(:polling, socket) do

    {:noreply, render_result(socket.assigns.vote_id,socket)}
  end

  def handle_event("press", %{"value" => symbol}, socket) do

    Poll.mark_vote(socket.assigns.vote_id, symbol)
    {:noreply, socket}
  end
  defp render_result(nil,socket) do
    Logger.info("Id does not exits...")
    socket
  end
  defp render_result(vote_id, socket) do
    result = Poll.get_votes(vote_id)
    chart = Poll.render_chart(result)
    socket|>assign(:svg_chart, chart)
  end


  def render(assigns) do
    ~H"""
    <div>
      <h3>Result</h3>
      <div>
      <%=@svg_chart%>
    </div>
    </div>
    """
  end
end
