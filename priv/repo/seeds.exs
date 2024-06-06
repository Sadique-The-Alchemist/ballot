# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ballot.Repo.insert!(%Ballot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ballot.Repo
alias Ballot.Poll.Vote
alias Ballot.Poll.Candidate

vote = %Vote{name: "Brand",type: :anonymous}|>Repo.insert!()
%Candidate{name: "Allensonly", symbol: "bull", vote: vote, color: "fbb4ae" }|>Repo.insert!()
%Candidate{name: "Louis philip", symbol: "plate", vote: vote, color: "b3cde3"}|>Repo.insert!()
%Candidate{name: "Otto", symbol: "card", vote: vote, color: "ccebc5"}|>Repo.insert!()
%Candidate{name: "Peter England", symbol: "man", vote: vote, color: "6295a2"}|>Repo.insert!()
