---
attachments: [Clipboard_2021-10-04-18-11-58.png, Clipboard_2021-10-04-18-15-02.png, Clipboard_2021-10-04-18-27-39.png]
title: Distributed Systems and Middleware Technologies
created: '2021-10-04T16:08:22.670Z'
modified: '2021-10-04T17:52:51.105Z'
---

# Distributed Systems and Middleware Technologies

## Concorrenza, definizione e principi

In un sistema moderno possiamo avere piu' unita' computazionali (Computational Units CU) che collaborano e interagiscono per ottenere il risultato finale. Lo scambio di informazioni tra le diverse unita' puo' avvenire in vari modi.

- Shared Memory Model: le informazioni vengono scambiate attraverso una memoria condivisa che puo' essere acceduta da tutti i processi. Puo' creare problemi di sincronizzazione in quanto dobbiamo essere sicuri che i processi non stiano scrivendo sulla stessa locazione di memoria condivisa.

![](@attachment/Clipboard_2021-10-04-18-11-58.png)

- Message Passing Model: consente lo scambio di informazioni senza essere direttamente collegati attraverso una coda di messaggi. Questo consente di costruire modelli paralleli pur richiedendo un tempo di accesso maggiore.

![](@attachment/Clipboard_2021-10-04-18-15-02.png)

### Processi vs Thread

I thread sono dei *processi leggeri* che condividono lo stesso spazio di indirizzamento. Molteplici thread possono essere eseguiti in modo concorrente e il cambio di contesto risulta essere piu' veloce rispetto a quello dei processi.

I processi invece non condividono lo stesso spazio di indirizzamento e di conseguenza devono comunicare attraverso metodi di comunicazione *inter-processo* come il message passing. 

### Rappresentazione formale di una computazione concorrente

Definiamo due insiemi:

- A: insieme delle azioni
- PC: insieme dei vincoli di precedenza

La precedenza e' una relazione matematica binaria che vincola l'esecuzione di un'azione ad un'altra.
L'insieme PC e' un insieme *parzialmente ordinato* (Partially Ordered SET, poset).

Per rappresentare l'esecuzione di un programma concorrente si puo' utilizzare un Direct Acyclic Graph (DAG). 

![](@attachment/Clipboard_2021-10-04-18-27-39.png)

In questo caso i nodi che hanno archi entranti sono soggetti a vincoli di precedenza, mentre quelli con solo archi uscenti non hanno vincoli di precedenza.
In generale posso eseguire due azioni in modo concorrente se seguendo gli archi non posso raggiungere l'altra azione. Ad esempio B e C possono essere eseguite in modo concorrente. Al contrario, le azioni non sono eseguibili in modo concorrente se sono direttamente raggiungibili tramite gli archi.

⪯<sub>p</sub> : simbolo usato per l'ordinamento parziale

⪯<sub>p</sub> = P<sub>p</sub><sup>+</sup> dove P<sub>p</sub><sup>+</sup> e' la **chiusura transitiva**.
La chiusura transitiva di una relazione R è un'altra relazione, tipicamente denotata con R<sup>+</sup>, che aggiunge ad R tutti quegli elementi che, pur non essendo necessariamente in relazione direttamente fra loro, possono essere raggiunti da una "catena" di elementi tra loro in relazione. In pratica, la chiusura transitiva di R è la più piccola (in senso insiemistico) relazione transitiva R<sup>+</sup> tale che R⊂R<sup>+</sup>.

- Non-strict partial order: relazione ordinata che e' 
1. riflessiva: a ⪯ a
2. transitiva: se a <= b e b <= c ==> a <= b
3. anti-simmetrica: se a<=b e b<=a ==> a = b ma non significa che se a <= b e a != b ==> b <= a

- Strict partial order: non ho piu' la riflessivita', ma l'irriflessivita' a < a.

Un altro problema che si pone e' che PC non e' necessariamente un insieme ridotto al numero minimo di elementi. Questo vuol dire che possiamo eliminare degli archi. Un metodo per eliminare gli archi superflui e' detto **calcolo del diagramma di Hasse**.
Anziche' effettuare la chiusura transitiva, effettuo la *riduzione transitiva* del partial order.

Voglio trovare il piu' piccolo R tale che R<sup>+</sup> = P<sub>p</sub><sup>+</sup> e per i DAG e' unico.

### Formalizzazione della definizione di concorrenza

$a_i \in A, a_j \in A$ sono eseguite concorrentemente **se e solo se** ne' $a_i ⪯_p a_j$ ne' $a_j ⪯_p a_i$.
