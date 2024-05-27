defmodule BallotWeb.PollLive do
  use BallotWeb, :live_view
  import BallotWeb.CoreComponents, only: [table: 1, button: 1]
  alias Ballot.Poll

  def mount(%{"vote_id"=> vote_id}, _session, socket) do
    Poll.start_vote(vote_id)
    candidates = Poll.list_candidates(vote_id)
    socket = socket|> assign(:candidates, candidates)|>assign(:vote_id, vote_id)
    {:ok, socket}
  end
  def render(assigns) do
    ~H"""
    <div>
    <.table id="candidates" rows={@candidates}>
    <:col :let={candidate} label=""><%=candidate.name%></:col>
    <:col :let={candidate} label=""><.button class="w-20" phx-click="press" value={candidate.symbol}> <%=candidate.symbol%></.button> </:col>
    </.table>
    </div>
    """
  end

  def handle_event("press", %{"value"=> symbol}, socket) do
     Poll.mark_vote(socket.assigns.vote_id, symbol)
    {:noreply, socket}
  end
end
