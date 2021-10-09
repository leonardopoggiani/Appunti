---
title: Note slide Distributed Systems 1
created: '2021-10-05T14:24:26.450Z'
modified: '2021-10-05T14:30:24.566Z'
---

# Note slide Distributed Systems 2

## Abstract Models: Synch vs Asynch

We want to discuss now about possible semantics for communication constructs.

Let’s again think of distributed systems from an abstract viewpoint.
There are 2 different abstract models we can consider, which refer to different ways I can think processes are executed over the machines composing the overall distributed system: 

- Synchronous model: 
whenever processes takes steps simultaneously. We can imagine the overall execution as carried out in synchronous rounds. This is a very simple abstract model to reason about, but it is not realistic: 
in distributed system we lack a global clock for all our nodes.
So, we can move to a more realistic model:

- Asynchronous model: 
we make no assumptions of relative timing of processes. The delays experienced by processes carrying out their activity, and the delays experienced in delivering messages, are potentially unbounded. In this case we have to deal with an asynchronous setting, where I cannot rely on any form of shared uniform global clock, and this will be complicated because we will have to find out something else to rely on for the ordering of activities, because I cannot trust any form of clock.

## Semantics for Send/Receive

Let’s talk about possible semantics for SEND and RECEIVE. 
Send and receive are considered, at our abstraction level, as primitives, that is at the high-level language abstraction we are discussing, we can consider them as primitives that is the smallest unit of processing, something that is atomic.

What is the possible behavior of them?

They can be either blocking or non-blocking:

- Blocking: 
suppose a process in execution has to perform a blocking op: it will stop there until the op will be completed. Remember that the finalization of the op depends not only by the process itself but it may depend also on what is done by other processes involved in the communication. (waiting op are possible)

- Non-blocking: the op is just fired, it starts and who cares about the completion of the whole op as it regards activities to be carried out by the other parties, I did my part and now I go on, it is up to other parties to do what they have to perform. 
If I want to use this last semantic (non-blocking), from a practical point of view we have to resort in some kind of buffering (incoming buffer = “mailboxes” in our jargon).
Non-blocking implies the need to implement buffering in the implementation of communication primitives, both for incoming and outcoming messages.


## Blocking vs Non-Blocking Send

BLOCKING SEND: 
the message has to be sent to the destination, and the sending process can resume the execution only upon getting sure that the message has been received. 

How can we be sure of this? Getting back a message. 
The implementation of a communication construct like this one will contain a sort of handshake: 
I have to be informed by the other that everything has been received correctly.  So I hide some complexity in the implementation of the construct and I just present the general semantic of the construct to the programmer.

NON-BLOCKING SEND:
the sender just send the message to the destination and does not wait for any kind of acknowledgment.
After performing the send op, the process will execute its next op and so on.
We talked about the need of message buffering: in this context what does it means “a message has been sent”?
It may mean several different things and we have to be sure under the specific semantics or a certain middleware platform I’m using what it means:
f.i. a message has been sent when it has been placed in the outgoing buffer; or when the buffer has been flushed because the daemon in my system has took care of taking the message and sending it out over the NW; etc.
Depending on the specific platform and system we will use, a single term may mean different things.

## Blocking vs Non-Blocking Receive

- Blocking Receive:
it checks the incoming queue (the mailbox) and until a message has been found there, it will stop the execution.
As soon as a message is available in the mailbox, the message is taken from there, will be actually received and the process can go on.

- Non-blocking Receive:
the check is done as soon as the construct is executed. If the message is there it will be actually received, otherwise the computation goes on without any kind of blocking.

Consider that from the performance point of view having blocking construct means making the program less efficient (you waste time in waiting), it depends on the kind of program you are developing.
Another important point is that the use of specific semantics in blocking/non-blocking pairs may lead to dead lock situation, so take care.

We can recall a famous construct that has been proposed at the beginning of the computer science era known as the Guarded Command:
It has a guard at the beginning, then an arrow and then an instruction. The instruction contains a receive op; the guard corresponds to a condition plus a blocking receive op. In case some condition is verified and the receive op can be completed, the part named instruction will be executed. This is a way to mix conditions about checking some property and getting some info once it is available from other processes. 

## Example: Scheme for Bounded Buffer

How these constructs can be used to solve a classical problem in distributed systems.

 The problem is the so called BOUNDED BUFFER.
The idea is: 
I have some space to keep some information, but the size is finite. This block of information can be inserted in the buffer by other processes (named producers) and can be extracted from there by consumers (processes). 
I want to organize the overall communication so that insertion and extraction of information blocks in/from the buffer will not turn into an overflow, I cannot insert an information block when the buffer is full, I cannot extract a block when it is empty.
I can imagine that the producer, before inserting an information block has to ask for a permit because it may happen that the buffer is full so it will have to wait for the buffer to have enough space before inserting the block. So, it has to request a permit to the buffer process.
It will receive the reply as soon as the permit can be granted, and once the permit has been obtained the producer can go on inserting the block by sending a message with that piece of information. So, in the interaction between producer and the buffer we can identify different reasons to exchange messages:
1. ask permit
2. give permit
3. insert the information block
So I can identifies 3 different endpoints: 2 on buffer side (getting the permit, getting the information block), 1 at producer side (to receive the permit).(the 3 interaction on the left). The 3 dots are the ports.

Interaction between consumer and buffer it is much simpler:
the consumer must only ask for a block, if the block is not there no problem: I have to wait for a message from the buffer, there is no need for any further handshake between the 2 --> 2 ports: 1 on consumer side to obtain the requested block, 1 on buffer side to receive the request coming from the consumer. 
If I do not use ports, or if I modify the semantics of send and receive I will have to figure out other solution. 

## Programming Paradigms

When we say paradigm, what do we means ?
A paradigm is a sort of a pattern, a way of doing something, typically we consider it as a way of thinking, and since we are talking about Programming Paradigm it is a way of programming . 

A way of programming does not mean just knowing special constructs to do something, but instead is a way to look at problems and structuring possible solution for that problems. 
A programming paradigm leads to the solution of the problem according to a certain number of principles. 

We know C and Java --> these leads you to find different kinds of solutions.
 
We are interested in 2 very broad programming paradigms:

- Imperative: 
we have sequences of commands, and these sequences drive the control flow of the program.

- Functional: 
there is no state mutation, but the computation is seen as the process of evaluating expressions or a sequence of expressions.


## Programming paradigms

When we say paradigm, what do we means ?
A paradigm is a sort of a pattern, a way of doing something, typically we consider it as a way of thinking, and since we are talking about Programming Paradigm it is a way of programming . 

A way of programming does not mean just knowing special constructs to do something, but instead is a way to look at problems and structuring possible solution for that problems. 
A programming paradigm leads to the solution of the problem according to a certain number of principles. 

We know C and Java --> these leads you to find different kinds of solutions.
 
We are interested in 2 very broad programming paradigms:

- Imperative: 
we have sequences of commands, and these sequences drive the control flow of the program.

- Functional: 
there is no state mutation, but the computation is seen as the process of evaluating expressions or a sequence of expressions.


## Imperative Programming


