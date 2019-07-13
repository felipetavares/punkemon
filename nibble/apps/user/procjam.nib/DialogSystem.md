# The Punkémon Dialog System

## 1 Conversations

In Punkémon, interactions between the player and other characters (NPCs),
or even between the player and other players, are grouped in units called
`Conversations`.

But in what consists such conversations? Before we dive into that, we must
first define **how** we group interactions together in conversations. How
we find out which interactions belong to the same group? This has a very
simple answer, we group by the set of characters involved in that
interaction.

For example, let's create two imaginary characters: `A` and `B`. There
is also the player, which we will call `P`. If an interaction happens
between `A` and `B`, we will put that interaction into the `(A, B)`
conversation. If it happend between `P` and `A`, it goes into `(P, A)`.
In case it happens between all three of them, it goes into `(P, A, B)`.

Those sets are unordered sets of course, so it does not matter if
I say we put something in the `(P, A)` conversation or in the `(A, P)`
conversation, as they are the same.

Now that we got that out of the way, we can discuss the more interesting
stuff: what are those conversations? What do we put in them? What kind
of "interactions" am I talking about?

Conversations are sets of messages that are displayed onscreen. Simple
as that. We can also imagine a conversation as a **stream** of messages:

```lua
function Conversation:next()
    ...
    return message
end
```

This method, when called, would return the next message in the conversation.

Now we arrive at the fundamental problem of the dialog system, since we must
return a message for each call, how we decide **which** message to return?
There can be several messages in the conversation, and a single one should
be returned. Which one?

Obviously we want to return the **next** message, so every message could just
point to the next one and problem solved! Not so fast, tiger! What about
player choices? Okay, so each message can have a few next messages, in such
a way we form a graph. Problem solved? Not really, because context can also
change as an **indirect** player choice, both at the start of a conversation
and at every new message (and also **inside** messages!).

It's clear that we need some form of managing and accessing context, but
at least we made some progress, now we know we need a **graph** to represent
a conversation.

One issue I hinted at but one that is fundamental is: since each messages knows
the next one, how do we know the **first** message? The problem is that
for the same set of characters there can be several first messages depending
on context. We work around that by having a message that is in the graph and is
always the first one, but it's not displayed: it exists merely to choose to
which message we should go next depending on the context.

Another similar problem we face is: how do we know when to allow the player
to leave the conversation? We must also have special messages that are not
displayed: exit messages, those messages simply close the graph.

## 2 Context

Now we can go back to the issue of having a global (as in common to all
conversations) and a local (only existis inside one conversation) context.

The simplest way we can do that is by having one global set of (key, value)
pairs and one local (key, value) set **per conversation**. We also need
a few other things to make this useful:

1. A way of setting and getting values inside those contexts;
2. A way of checking those values and executing actions based on that.

Sowe essentially need as simple language with:

a) variable access;
b) the `=` operator;
c) the `if` keyword;
d) boolean expressions support.

Since this is not a language for programmers but rather for content designers,
it makes sense if text is the focus rather than keywords: everything is a comment
and "comments" are code.

## 3 Syntax

First, a few considerations on the syntax:

- We need a way to separate messages inside a conversation
- A way to link messages together
- A way to accept user input on messages

I find it import to sometimes have source of inspiration, something that people
who work with the problem in other contexts use. In this case the first thing
I can think of is that script writers, whose sole job is to write those little
conversations (plus a lot of other stuff, probably), write **scripts**! So a format
that is inspired by scripts will have two advantages out of the box:

1. Can be easily used by script writers
2. Encodes years of knowledge

But, it is also important to be critial of your inspiration: we are not going to
simply add something to our language because it so happens that this "feature" is
also present in scripts. We instead will selectively choose fetures that are
important for us and maybe even roll out a few of our own.

   
