# Portal

Practicing some pure elixir/erlang concepts to keep it fresh,
phoenix is great but staying sharp with elixir will only help.
This is the portal game from a [post](http://howistart.org/posts/elixir/1)
by the creator himself.

Ultimately we end up with a supervisor that can handle an arbitrary number
of children. These children are each an
[Agent](http://elixir-lang.org/docs/stable/elixir/Agent.html)
whose state represents a stack. Standard `Push` and `Pop` operations
can be performed on the stack. The cool part involves popping
from one agent and pushing on to another, thus transfering values.
