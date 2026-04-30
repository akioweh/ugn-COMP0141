#import "/style.typ": aside, note, note-ref, theme
#import "@preview/booktabs:0.0.4": *

#set document(title: "COMP0141")

#show: theme
#show: booktabs-default-table-style


#title()

Security

This course is about "understanding information security: how attacks work, how they can be prevented, and the importance of 'thinking about the human'... and above all, how to think with a security mindset".


= What is Security?

_Safety_ protects against unintentional harm, while _security_ protects against intentional threats.

In _CS_ security,
- correctness,
- safety, and
- robustness
must hold even against a powerful adversary.


/ The _Bruce Schneier_ Security Mindset: A habitual practice of thinking how a system can be subverted or broken instead of just how it _normally_ works fine; thinking like an attacker. One will never notice most security problems without thinking like this.

== Security Properties

The *CIA Triad* are 3 core properties in security:
/ Confidentiality: data being inaccessible by the unauthorized
/ Integrity: data being correct (not altered by the unauthorized) over its lifespan
/ Availability: data being accessible whenever required

Other properties beyond CIA:
/ Privacy: (note: confidentiality belongs to data, while privacy belongs to individuals)
/ Authenticity: (note: integrity pertains to the data itself, while authenticity pertains to its source)
/ Anonymity: (note: privacy is about hiding the action, while anonymity is about hiding the author)
/ Non-repudiation: individuals being unable to deny any messages they've sent
/ Plausible deniability: ability to credibly deny actions (a stronger form of the negation of non-repudiation)
/ Forward secrecy: compromise of long-term keys does not compromise past session keys (and so past traffic)

== Security Definitions

To _design_ a secure system, one first needs to _define_ the criteria for security. \
Two philosophies:
/ Binary: A system is either secure or insecure. Cryptography uses a binary model.
/ Risk management: A system is secure to some acceptable level

Binary definitions are hard to get right (and consequences can be tremendous).
Risk management, however, often presents a lot of trade-offs (e.g. between availability and integrity).

Cost-wise, risk-management is usually more suitable than a binary system.

== Threat Modeling

_Threats_, _vulnerabilities_, _likelihood_, _impact_, and _cost_ are used to create a _threat model_.

Systems are not just _secure_, but secure under _some_ threat model. \
A *system is secure* if an adversary, constrained by some given threat model, cannot violate the security policy.

=== Threats

An adversary has access to a set of _resources_ to:
- observe (sniff packets)
- disrupt (jam radio comms)
- influence (social engineering)
- modify (alter packets in transit)
- control (influence trusted users)

A _strategic_ adversary uses resources _optimally_ (to maximize their objective subject to constraints).

*STRIDE* is a model to analyze threats:

/ Spoofing: impersonation (Authenticity)
/ Tampering: modification of data (Integrity)
/ Repudiation: claiming (whether honestly or not) a lack of responsibility (Non-repudiation)
/ Information disclosure: unauthorized access (Confidentiality)
/ Denial of service: exhausting / overwhelming a server's ability to provide service (Availability)
/ Elevation of privilege: gaining higher access privileges than authorized (Authentication and Access Control)

=== Vulnerabilities

Vulnerabilities are what _enable_ a threat.
Adversaries _exploit_ vulnerabilities to cause harm.

=== Likelihood

The likelihood of failure.
This can vary depending on the state of or input to the system.
It also depends on who the adversary is (their expertise and motivations).

=== Impact

The consequences in the event of a successful attack.
Once again, depends on many state variables and the extent of the attack itself.

=== Protection

The initiatives taken to achieve security.
Always has some _cost_ and some finite effectiveness.

== Human-centered Security

One has to consider *goals*: why are people using this system?

/ Usability: How well a (specific) user (in a specific context) can use a product to achieve a _defined goal_ effectively, efficiently, and satisfactorily.

_Time_ is a major hidden cost.

Of course, usability and security usually come at a trade-off against each other.

Usability can be evaluated by
- cognitive walkthrough by usability experts
- user studies
- telemetry

Common problems and ways to improve:
- Users lack intuition: provide education and training
- No one to maintain the security of personal devices: make security invisible
- Difficulty in estimating risks: education
- Users avoid secure methods due to complexity: make security the path of least resistance


#pagebreak()
= Design Principles & Background

== Design Principles

General considerations when designing secure systems.

The following 8 principles spell out ELLF COPS.

/ Economy of Mechanism: Keep designs as simple and small as possible. Simpler = easier to understand, less likely to contain flaws.

/ Least Privilege: When configuring access control, provide each user with the minimum access required for them to do their job.

/ Least Common Mechanism: Minimize mechanisms (state, services, channels) shared across users or security domains.
  Shared mechanisms are inherently trusted by all parties using them and are prone to leaking covert channels.

/ Fail-safe Defaults: The "default" state (e.g. during unforeseen errors) should not violate security principles.
  E.g., using a white-list instead of a black-list for access control.

/ Complete Mediation: Every access to every object should be checked for authority.

/ Open Design: A system's security should not depend on an adversary's ignorance of its design. (security by obscurity)

/ Psychological Acceptability: A system's secure mechanism should be at least as easy as not using it. (path of least resistance)

/ Separation of Privilege: No single condition (or single party) should suffice to grant access; require multiple independent checks.

Additional principles:

/ Defense in Depth: Not allowing a single vulnerability to compromise the entire system.

/ Design for Updating: Vulnerabilities will always be discovered, so make your system updatable.

/ Prudent Paranoia: Don't underestimate the effort adversaries will go to. "Just because you're paranoid doesn't mean they aren't after you."

/ Privacy Promotion: // TODO: definition

// Trusted Computing Base is defined and discussed in §"Access Control" below.

== Networking

// TODO: TCP/IP, DNS, packets, routing basics

== Math

(not sure why this is in this section)

$x | y$ ~ means x is a factor of y (think: x "goes into" y).

$(exists a in ZZ : z = a x + y) quad <==> quad z equiv y thick (mod x)$ \
$z equiv y thick (mod x) quad <==> quad x | (z - y)$

$gcd(a, b) = max(d : d | a "and" d | b)$

=== Euclidean Algorithm

Efficiently calculate $gcd(a, b)$.

```py
def gcd(a, b):
  while b:
    a, b = b, a % b
  return a
```

=== Extended Euclidean Algorithm

/ Bezout's identity: $forall a, b in ZZ : exists x, y in ZZ thick : gcd(a, b) = a x + b y$

Efficiently calculate $x, y$ s.t. $gcd(a, b) = a x + b y$

```py
def egcd(a, b):
  x, x1 = 1, 0
  y, y1 = 0, 1
  while b:
    q, r = divmod(a, b)
    a, b = b, r
    x, x1 = x1, x - q * x1
    y, y1 = y1, y - q * y1
  return a, x, y
```

=== Modular Arithmetic

All ring axioms (associativity, commutativity, distributivity) are preserved for $+$ and $times$. \
Exponentiation works in the exponent _modulo $phi(n)$_, not modulo $n$: when $gcd(a, n) = 1$, $a^x equiv a^(x mod phi(n)) thick (mod n)$ (Euler's theorem).

For further stuff regarding *commutative rings* and *modulo addition groups* or *modulo multiplication rings*, see https://akioweh.com/shared/COMP0147#modular-arithmetic.

/ Multiplicative Inverse: $a^(-1)$ is an inverse of $a$ under some modulo $n$ iff. $a^(-1) times a equiv 1 thick (mod n)$.

An element $x$ of some $frac(ZZ, n ZZ, style: "horizontal")$ has a multiplicative inverse iff. $gcd(x, n) = 1$ (i.e., $x$ and $n$ are coprime). \
If $gcd(a, n) = 1$, then $a x + n y = 1$ by Bezout's identity, and so $a x equiv 1 thick (mod n)$, giving $x$ as the inverse of $a$. \
The proof in the other direction is literally the same thing reversed.

Multiplicative inverses are unique.
Evidently, the extended Euclidean algorithm computes them efficiently.

A _field_ is an abelian group under addition whose _nonzero_ elements form an abelian group under multiplication, with multiplication distributing over addition.
(0 has no multiplicative inverse.)

/ Prime Order Finite Field: $frac(ZZ, p ZZ, style: "horizontal")$ where $p$ is prime.
  (Note: there are also finite fields of prime-_power_ order $p^k$ for $k > 1$, but those are _not_ $frac(ZZ, p^k ZZ, style: "horizontal")$ — that latter ring is not even a field.)


#pagebreak()
= Confidentiality

== Cryptography

=== Math

The security of a cryptography system is always tied to some _hard_ problem, e.g. the discrete logarithm.

Important algebraic structures:
- large prime order finite fields $F_p$ ~ ($p >= 2^1024$);
- multiplicative rings modulo large $n = p q$ ~~ $frac(ZZ, p q ZZ, style: "horizontal")$ ~ ($p, q >= 2^1024$ and are primes).

Finite fields' value in encryption comes from the discrete log problem; multiplicative rings' value come from the factoring problem. \
Discrete log is also hard in composite multiplicative rings (in fact, at least as hard as factoring), but prime fields admit cleaner subgroup structure for DL-based protocols.


/ Discrete Logarithm: Given $b$, $y$, and prime $p$, find $x$ s.t. $b^x equiv y thick (mod p)$.

/ Factoring Problem: Given $N = p q$ (different odd primes), find $p$ and $q$.

/ RSA Problem: (Rivest, Shamir, Adleman) Given $N$, $e$, and $y$, find $b$ s.t. $b^e equiv y thick (mod N)$. ($N = p q$, different odd primes.) _Believed_ to be as hard as the factoring problem.

/ One-Way Functions: A function that is easy to compute, but (believed to be) very difficult to invert or find two inputs with the same output. Modular exponentiation (whose inverse is the discrete log _problem_) and integer multiplication of primes (whose inverse is the factoring _problem_) are candidate one-way functions.

=== Classic Ciphers

Most classic ciphers are _substitution_ ciphers: each plaintext letter is replaced by another according to some rule.
They split into _monoalphabetic_ (one fixed substitution) and _polyalphabetic_ (the substitution varies by position).

==== Monoalphabetic Substitution

A single permutation $sigma in S_n$ (over an alphabet of size $n$) is applied to every letter.
Key space is $n!$ but trivially broken by frequency analysis on any non-trivial ciphertext.

/ Caesar shift cipher: special case where $sigma$ is a cyclic shift.
  Key is a single element of $ZZ slash n$; only $n$ possible keys (brute-forceable).

==== Polyalphabetic Substitution

The substitution varies by position; the parent class of Vigenère, running-key, and Enigma.
Defeats simple frequency analysis on the ciphertext as a whole, but periodic schemes leak structure once the period is found (Kasiski examination, index of coincidence).

/ Vigenere Cipher: rotates through a fixed-length sequence of $k$ independent Caesar shifts.
  Key is in $(ZZ slash n)^k$.
  Periodic, so vulnerable once $k$ is recovered.
/ Running Key Cipher: Vigenère with the key drawn from a long, structured source (e.g. a book).
  No fixed period, but the key is non-random.
  Statistical attacks on plaintext-on-plaintext still apply.
/ Enigma: rotor machine implementing a position-varying substitution with very long effective period; broken via known-plaintext (cribs) and operational mistakes, not a flaw in the substitution principle.

==== Beyond Substitution

/ One-time Pad: Each plaintext letter is combined with a corresponding key letter via modular addition.
  Requires a secret key at least as long as the plaintext.
  Information-theoretically unbreakable if the key is truly random, secret, and used only once.
  (Vigenère with a truly random key as long as the message _is_ a one-time pad.)


== Symmetric Encryption

- stream ciphers: a key + nonce/IV generates a keystream that XORs with arbitrary-length plaintext.
- block ciphers: a primitive that encrypts fixed-size blocks under one key. Encrypting longer messages requires a _mode of operation_ (CBC, CTR, GCM, ...); some modes pad, others (e.g. CTR) don't.

// TODO: AES details (Rijndael, rounds, S-box, key sizes)

=== Key Exchange

The Diffie-Hellman (DH) key exchange protocol allows two people to create a shared secret key over an insecure communication channel without ever sending the key itself.

+ *Public parameters* \
  Alice and Bob agree on prime $p$ and a generator $g$ of a large prime-order subgroup of $(ZZ slash p)^*$.
  (Using a full-group generator leaks one bit of each secret via the Legendre symbol.)

+ *Private Keys* \
  Alice picks secret $a$. \
  Bob~~ picks secret $b$.

+ *Public Keys* \
  Alice computes $A = g^a mod p$ ~ and sends it to Bob. \
  Bob~~ computes $B = g^b mod p$ ~ and sends it to Alice.

+ *Shared Secret* \
  Alice computes $S = B^a mod p$. \
  Bob~~ computes $S = A^b mod p$. \
  Both results are identical due to, well, math.

This is secure as 1 the discrete logarithm problem makes it hard to deduce $a$ or $b$ from $A$ and $B$, and 2 the _Computational Diffie-Hellman_ (CDH) assumption makes it hard to compute $S$ from $A$ and $B$ alone.
(CDH is implied by DL but not proven equivalent.)

Note that DH does not _authenticate_ the parties and is thus vulnerable to man-in-the-middle (MitM) attacks.
An attacker could sit in the middle, pretend to be Bob to Alice and Alice to Bob, establishing two separate secrets.
This allows eavesdropping (and integrity violations) invisible to Bob and Alice.


== Asymmetric Encryption

Asymmetric encryption (aka. public-key cryptography) mainly solves logistical constraints of symmetric encryption. \
A problem of symmetric encryption arises in many-to-many communication setups: the number of keys in the system scales quadratically.


/ Encryption Oracle: A black-box entity that encrypts any plaintext on demand.

/ Decryption Oracle: A black-box entity that decrypts any ciphertext on demand.

/ Chosen Plaintext Attack: (CPA) Adversaries that have access to an encryption oracle. E.g., influencing the message of a sender and then snooping the ciphertext in transit.

/ Chosen Ciphertext Attack: (CCA) Adversaries that have access to a decryption oracle.

/ Indistinguishability from CPA: (IND-CPA security) A security property where CPAs do not allow an adversary to distinguish between the ciphertexts of one chosen plaintext from another.

/ Indistinguishability from CCA: (IND-CCA security) A security property where CCAs do not allow an adversary to distinguish between the ciphertexts of one chosen plaintext from another. This is strictly stronger than IND-CPA.


*RSA*:
- choose 2 large primes $p$ and $q$
- let $N = p q$
- choose Public Key $e$ s.t. $gcd(e, phi(N)) = 1$ ($phi(N) = (p - 1)(q - 1)$)
- compute Private Key $d$ s.t. $e times d equiv 1 thick (mod phi(N))$ (the inverse of $e$).
  (Modern implementations use Carmichael's $lambda(N) = op("lcm")(p-1, q-1)$ instead of $phi(N)$, yielding a smaller $d$; both work.)

$(N, e)$ is the public key; $(N, d)$ is the private key.

$op("Enc")(M) = M^e mod N$ \
$op("Dec")(C) = C^d mod N$

NOTE: "textbook" RSA encryption (above) is _not_ IND-CPA secure: it's deterministic (same $M$ ⇒ same $C$) and malleable.
Real schemes randomize via padding (OAEP).


=== random details

One-way functions' existence depend on P $!=$ NP, which is _unproved_.
(P $!=$ NP is necessary but not sufficient: OWFs need average-case hardness, not just worst-case.) \
Even many symmetric ciphers that do not depend on one-way functions, like AES, are also _unproved_ regarding their security.
In practice, the agreement of an algorithm's security is purely social (based on the lack of vulnerabilities found after "significant" scrutiny)

Positive indicators (e.g. padlock icon when secure) are easily ignored or spoofed; _negative_ indicators (warn when security is _absent_) are preferred — users react to alerts, not the absence of them.


#pagebreak()
= Integrity

...the state of being unaltered (by the unauthorized).

Digital signatures provide authenticity (and integrity), addressing the MitM vulnerability identified earlier in DH key exchange.

/ Authenticated Encryption: encryption + signature / message authentication checks to achieve both confidentiality and integrity (+ authenticity).

== Digital Signatures

For RSA specifically, the setup mirrors asymmetric encryption with the "private" and "public" keys swapped: one uses the private key to compute the _signature_ of a message by treating the message as a ciphertext and "decrypting" it, and then anyone can use the public key to re-"encrypt" the signature and check that it matches the original message.
(This key-swap intuition is RSA-specific; ECDSA, EdDSA, and hash-based signatures don't follow this pattern.)

For RSA, follow the same keygen procedure, then \
$(N, e)$ is (still) the public key; $(N, d)$ is the signing (private) key.

$op("Signature")(M) = M^d mod N$ \
$op("Verify")(M, sigma): "check that" sigma^e equiv M thick mod N$

/ Existential Unforgeability under Chosen Message Attack: (EUF-CMA security) An adversary cannot produce a valid signature for _any_ new message, even after adaptively obtaining signatures on messages of their choice from a signing oracle.

NOTE: "textbook" RSA (what we have here) signatures are _not_ EUF-CMA.
Forgery without oracle: pick $sigma$, set $M = sigma^e mod N$ and the $(M, sigma)$ pair is valid (although no control over $M$'s content).
Forgery with oracle: RSA is multiplicatively homomorphic, so $sigma_1 sigma_2$ signs $M_1 M_2$ for any two pairs of message-signatures.
Real schemes sign $"pad"("hash"(M))$, not raw $M$.

== Message Authentication Codes

Like signatures, but uses shared-key primitives (e.g. HMAC, CMAC).
Verification requires the same key, so MACs prove integrity + authenticity to anyone holding the key but cannot establish non-repudiation.

== Hash Functions

/ Cryptographic Hash Function: A hash function with pre-image resistance, second pre-image resistance, and collision resistance.
  Uniformity and the avalanche effect are typically also required to achieve the resistances.

/ Avalanche Effect: ...where even small changes in input yield large changes in output.

/ Uniformity: The property where the output distribution is uniform against random inputs.

/ Pre-image Resistance: Given $y$, it is hard to find $x$ s.t. $H(x) = y$.

/ Second Pre-image Resistance: Given $x$, it is hard to find $x' != x$ s.t. $H(x) = H(x')$.

/ Collision Resistance: It is hard to find any non-equal pair $x, x'$ s.t. $H(x) = H(x')$.

Strong avalanche effects typically imply good uniformity...

Applications of hash functions:
- checksums
- message authentication codes
- digital signatures
- blockchains
- password storage

$op("HMAC")(K, M) = H lr(((K xor "opad") || H lr(((K xor "ipad") || M), size: #125%)), size: #125%)$

== Mapping to STRIDE

Keyed hashes (MACs) or signatures could prevent Spoofing, Tampering, Repudiation, and Elevation of privilege (in STRIDE).
(Unkeyed hashes alone don't authenticate; an attacker can recompute them.) \
Encryption (in addition to powering signatures) could prevent Information disclosure and Elevation of privilege (in STRIDE).


== Digital Certificates

_X.509 certificates_ are used to prove the ownership of a public key.
To communicate with a given domain, you need its public key.
X.509 is important to ensure any public key you receive is actually associated with the claimed domain and did not come from an impersonator (Authenticity and MitM).


#pagebreak()
= Human-centered Security

== Thinking Socio-Technically

To build truly robust security systems, one must avoid viewing technical and social aspects in isolation.
A _socio-technical_ approach combines
- technical elements: authentication, encryption, identity management systems, etc.
- social elements: people, workplace culture, usage context, user limitations...

_Security is a process, not a product._

- Design _with_ humans, not just _for_ humans: understand user needs and limitations through testing, feedback, and observation.
- Understanding interactions: how people interact with technology "in the wild" is often very different from various idealized constructs
- Managing constraints: the user can#emph[not] do a lot of things, like remembering a long random password that changes every week

A critique of human-centered design is that while it improves systems for those involved in the design process, it may inadvertently make it worse for those who are not.

== Humans are (not) the Weakest Link

A "myth" is that humans are the _weakest link_ in security.
However, research shows that users do _care_ about security and intend on doing the right thing.
Instead, users fail due to:
- a lack of awareness (of threats)
- not being told correct and _actionable_ mitigation strategies (despite threat awareness)
- the system having low usability, forcing _shadow security_ practices (e.g. writing passwords down)

/ Primary vs. Secondary Tasks: Security is almost never a user's _primary_ task; their goal is to complete their work (e.g. messaging friends, accessing the web), rendering security a _secondary_ task that often even becomes a _barrier_ to the primary goal.

== Users vs. Management

- Users are not the enemy: \
  Security departments often view users as a liability.
  They should instead be treated like _partners_;
  security policies must be compatible with _existing_ practices; otherwise, they will be circumvented as users need to continue performing their primary tasks.
- Security managers are not the enemy: \
  Security managers generally also do (intend to) consider user needs.
  However, they're often inhibited by restrictive organizational structures; mutual distrust develop between users and IT departments, making policies ineffective and unenforceable.
- Security Policies: \
  Policies are often developed in isolation without consulting the users.

== Designing Usable Systems

A system that lacks usability is fundamentally insecure as users will misuse or circumvent it.

/ The 5Es of Usability: (from Whitney Quesenbery) Effectiveness, Efficiency, Engagement, Error Tolerance (allowing users to recover from mistakes), and Ease of Learning.

NOTE that the slides incorrectly attributes these to the Nielsen Norman Group...

/ Affordances & Signifiers: An _affordance_ is a relationship between an object and the actions it permits (a door affords pulling); a _signifier_ is the perceptible cue that communicates the affordance (the pull handle).
  Systems should make secure actions both afforded and signified.

Case studies:
- Access-controlled doors: a standard swing door with a badge reader is technically secure, but socially insecure (coworkers will politely hold the door open for each other, violating policy).
  A physical turnstile that only allows one person at a time designs _around_ the social limitation.
- Encryption: PGP 5.0 was technically brilliant but very unusable, causing users to expose keys or send plain text by accident.
  In contrast, WhatsApp integrated end-to-end encryption transparently, leading to mass adoption of this secure system.
- Passwords: professionals want complex, unique, expiring passwords.
  Users want to log in and do their work.
  Forcing such high complexity ends up with users doing worse things (_shadow security practices_) like writing passwords on sticky notes.

== Human Limitations & Cognitive Biases

Memory limitation:
- short-term / working memory: ~4 chunks at a time (Cowan, 2001; Miller's classic "7 ± 2" is now considered an over-estimate)
- long-term memory: relies on habits and requires periodic refreshers

Cognitive Biases:

/ Optimism Bias: "This won't ever happen to _me_."
/ Anchoring Bias: The first piece of information disproportionately shapes subsequent estimates.
  E.g., the first quoted "risk level" frames how seriously a user takes everything that follows.
/ Status Quo Bias: "I did it before, so I'll do it again."
  Users stick with prior choices and habits.
/ Consensus Bias: "Everyone probably reuses passwords like I do, so it's fine."
  (false-consensus: assuming others share your behaviors)
/ Hyperbolic Time Discounting: "I'll worry about security tomorrow; I have to finish my work today."

Attention and Inattentional Blindness:

- Users experience "security fatigue".
  Frequent warnings or false positives cause users to become desensitized and ignore them.
/ Inattentional Blindness: One only perceives what one focuses on. ("Gorillas in our midst" experiment.)
  Users often do not notice security red-flags because they never focused on security to begin with (but rather the work they are doing).

== Security Awareness & Behavior Change

Awareness campaigns should move beyond just making people scared;
they should provide simple actionable steps.

/ Fogg Behavior Model: Users need Motivation, Ability (system usability), and a Prompt to change behavior.

/ MINDSPACE Framework: Factors influencing behavior change include Messenger, Incentives, Norms, Defaults, Salience, Priming, Affect, Commitments, and Ego.

*Simulated phishing* attacks can train staff to spot malicious indicators and may identify organizational vulnerabilities.
However, adversaries continually adapt, requiring frequent training or obsolescence.
This can also backfire by making employees ignore genuine warnings due to desensitization.
This also creates profound distrust between employers and employees.

Punishing poor behavior (a *deterrence* strategy) is often ineffective as users circumvent policies out of necessity, not malice.

*Sanctioning* leads to non-reporting; users would rather hide their mistakes out of fear, stopping the IT from spotting vulnerabilities or responding to damage.

== Accessible Security

Security should be designed universally.
Designing only for the _average_ user leaves massive vulnerabilities for marginalized populations.


#pagebreak()
= Availability & Malware
== Importance of Availability

(recall the definition of Availability from the CIA triad.)

If availability is compromised,
- operational disruption
- poor user experience -> reputational damage
- material (commonly financial) damage
- cascading systematic effects

Primary threats to availability
- hardware failure: reliability engineering issues; solved via redundancy
- malware
- Denial of Service attacks: intentional attacks, usually externally, without malware within the system

Many fundamental internet protocols (TCP/IP, BGP) were built on trust (initially used only in institutional research).
They lack mechanisms to prevent / mitigate many forms of denial-of-service attacks.
Core redesigns are necessary, but impossible to deploy globally.

== Denial of Service (DoS) Attacks

/ Denial of Service Attack: Preventing _authorized_ access to a system or resource, usually by exhaustion achieved via techniques like _amplification_.

/ Resource Exhaustion: A mechanism to execute DoS: intentionally consuming a finite resource until none is left for legitimate users.
  _Flooding_ is the volumetric subcase; algorithmic-complexity attacks exhaust without flooding. \
  *Volumetric*: saturating (network) link bandwidth (e.g. UDP floods). \
  *Protocol*: saturating protocol-state limits in software (e.g. TCP connection tables, using SYN floods). \
  *Application*: exhausting compute resources (e.g. RAM, CPU, database connections).

As the Application layer is usually more shielded from the outside world, application layer attacks are often enabled by internal vulnerabilities (e.g. a memory leak in service software).

/ Vulnerability-based DoS: A mechanism to execute DoS: exploiting vulnerability or logical flaw to stop a service completely. \
  *Hard Crashes*: using (e.g. malformed) inputs or vulnerabilities to trigger a software crash. \
  *Infinite Loops*: using a vulnerability to exhaust CPU. \
  *Account Lockout*: intentionally triggering a security mechanism (e.g. repeatedly entering incorrect passwords) to stop the actual user from accessing their account.

As should be evident, some DoS vectors are created by security mechanisms themselves, like account lockouts.

/ Permanent DoS: (PDoS) stuff like physical destruction. Also includes *_Phlashing_*: exploiting firmware-bricking vulnerabilities; and vulnerabilities that cause permanent data deletion.

=== Network DoS

(here we specifically focus on DoS in the TCP/IP stack.)

==== Link Layer

802.11b Wi-Fi (Ethernet / physical links are relatively more secure)

- Jamming: simple continuous transmission on the 2.4GHz freq (with enough power to drown out others)
- Network Allocation Vector (NAV) Bug: setting the 15-bit channel-reservation field to its max value prevents other nodes from transmitting
- De-authentication Bug: "de-auth" packets can be sent without authentication, so one can repeatedly kick users off an Access Point.

==== Network Layer

IP

- Smurf Attack: (Data Flood) attacker spoofs the source IP with victim's IP and sends ICMP Echo Requests (pings) to a network's _broadcast address_.
  All devices on that network replies, to the victim.
  This effectively multiplies traffic by the size of the broadcast network.

BGP (note: BGP is technically an Application Layer protocol (it sits on top of TCP))

- Route Hijacking (BGP Trust Vulnerability): BGP relies on trust.
  (Pakistan Telecom, 2008) tried blocking YouTube domestically by using BGP to route traffic to black hole. They used a `/24` address mask, which was more specific than YouTube's actual `/22` mask, and since specific paths are preferred over broad ones, it caused all YouTube traffic globally to get sent to Pakistan.

==== Transport Layer

TCP

TCP's 3-way handshake (SYN $->$ SYN/ACK $->$ ACK) is exploitable.
- Low-rate SYN Flood: attacker sends victim SYN packets with random spoofed source IPs.
  The victim stores state in memory for each packet, waiting for ACKs that never arrive, exhausting the half-open connection backlog queue.
  Mitigation: SYN cookies.
- Massive SYN Flood: a botnet sends a crapton of SYN packets, saturating network links.


==== Application Layer

- DNS Amplification: attacker sends a DNS request spoofed with the victim's IP address using EDNS extensions to resolver.
  The packet itself is 60 bytes, but the response is ~3000, creating 50x _amplification_.
- Memcached Attack: (Github, 2018) amplification exploit using public memcached caching servers.
- TCP Connection Flood: Botnets complete full TCP handshakes and moves the flooding to application connections (e.g. HTTP requests).

More on memcached: \
memcached is a in-memory caching software, like an older, simpler version of Redis.
Misconfigured (passwordless) exposed servers allowed anyone to 1. "save" a large value 2. "get" this large value, except with a spoofed address so the large response goes to the victim.
memcached used to use UDP by default, making the spoofing trivial (does not require connection handshake like TCP).

=== Notable Attacks

- Estonia (2007): Massive political attack hitting government/bank sites using ICMP and TCP SYN floods.
  Estonia mitigated it by blocking all foreign web traffic.

- Root DNS Servers (2007): Botnets attacked the 13 root internet servers.

- Slammer Worm (2003): Exploited MS SQL Server via a single 376-byte UDP packet.
  Saturated internet links globally in under 10 minutes.

- Mirai (2016): Botnet comprised of millions of poorly secured IoT devices (cameras, fridges) running default credentials.
  Attacked Dyn DNS, knocking out Twitter, Reddit, and Netflix.


=== DoS Mitigation Strategies

==== Architectural Defenses

Proxies

- Content-Delivery Networks (CDNs) & Scrubbing Proxies: (e.g. Cloudflare, Akamai) distribute load globally.
  Proxies sit in front of the web server, handle the handshakes, and only forward fully established TCP connections to absorb SYN floods.
  CDNs remove the vast majority of the load from the origin server to absorb even application-layer attacks.
- SYN Cookies.
  When the server receives a SYN packet, instead of saving the connection details in memory, it encodes them into a 32-bit Initial Sequence Number (ISN): a coarse timestamp counter, a small MSS index, and a MAC of the client's IP/port + a server secret.
  The server sends a SYN-ACK back with this ISN as the TCP header's Sequence Number.
  If the client is legitimate, it will respond with an ACK packet.
  The client's "Acknowledgement Number" is always the server's Sequence Number + 1.
  The server subtracts 1 from the acknowledgement number, re-calculates the hash using the packet's info and compares.
  If they match, the connection is legitimate and only then will the server allocate memory for it.

==== Rate Limiting & Filtering

- Client Puzzles: a proof-of-work mechanism requiring clients to solve moderately hard computational problems (very similar to crypto mining).
  A drawback is of course that the computational power varies greatly from professional workstations to mobile devices...
- CAPTCHAs: application-layer human verification
- Ingress Filtering: ISPs drop outgoing packets if the source IP is not from within the network (indicating spoofing).
  Of course, as long as one ISP does not do this, then its users can more easily perform spoofing.

==== Source Identification

Regarding source IP spoofing: discovering the true origin of spoofed packets to block them at the source.

- Edge Sampling: (aka. Probabilistic Traceback) routers probabilistically mark a small proportion of packets with their IP edge data (start, end, distance) (into the 16-bit IP identification field).
  The victim statistically reconstructs the probable path.
  The expected number of packets needed is $E(X) < ln(d) / (p(1-p)^(d-1))$ where $d$ is the path length, $p$ = marking proportion.


== Botnets

/ Botnet: A network of compromised machines (aka. bots/zombies/drones) controlled remotely by a _botmaster_.

Botnets are used for _Distributed_ DoS (DDos), spamming, email harvesting, keylogging, crypto-mining, hosting proxy _stepping-stones_, etc.

/ Command & Control: (C&C) The architecture used to control a botnet: \
  *Centralized*: push style (IRC channels) or pull style (HTTP polling). Single point of failure. \
  *P2P*: (local) network relay chains. More robust and stealthy. Uses custom protocols or blends in with standard ones. \
  *Domain Generation Algorithms*: (aka. Domain Flux) C&C is located at some domain that is not communicated or within the bot itself, but is generated using some deterministic algorithm. Super stealthy when done right.

=== Takedown Strategies

- Attack C&C Infrastructure: seize domains or take down IRCs
- De-peering: disconnecting hosting services that "don't care" about malicious services from the wider internet.
- Honeypots: deploying deliberately vulnerable bait targets to get infected; researchers can then study / reverse-engineer malware.

== Malware

Malware is no longer written for fun, fame, or vandalism (as in the 80s/90s); most malware now are sophisticated profit-driven criminal efforts.

=== Taxonomy

Parasitic (Need a host program)
- Viruses
- Trojan horses
- Logic bombs

Self-contained / Standalone
- Worms
- Rootkits
- Spyware

=== Parasites

#table(
  columns: (auto, 1fr, 1fr),
  align: horizon,
  toprule(),
  table.header([Feature], [Viruses], [Worms]),
  midrule(),

  [Independence], [Parasitic], [Standalone],
  [Activation], [Requires human interaction (open file or run program)], [Autonomous],
  [Replication],
  [By attacking itself to other files on the _same_ system],
  [By sending copies of itself to _other_ systems over a network],

  [Speed of Spread], [Moderate, limited by users], [Rapid, no realistic limit],
  [Defense],
  [AV Scanners, Sandboxing],
  [Intrusion detection systems (IDS), Firewalls, Low-level exploit protection (e.g. ASLR)],

  bottomrule(),
)

// TODO: subsections on Viruses (in-depth) and Worms (in-depth)

=== Trojans, Spyware, and Rootkits

/ Trojan Horse: Malware disguised as legitimate, useful software.
  Relies entirely on social engineering.
  Cannot self-replicate.
  Often opens backdoors.

/ Spyware & Keylogger: Malware that secretly monitors user behavior.
  Keyloggers capture keystrokes to steal passwords, card numbers, etc.

/ Rootkits: Advanced malware designed to remain completely invisible and maintain privileged access. \
  *User-space Rootkits*: replaces standard utilities (e.g. `ls`, `ps`, `syslogd`) \
  *Kernel-space Rootkits*: modify privileged kernel memory directly; near-impossible to detect or remove from within the running OS. \
  There's also lower-level malware on the bootloader level.


#pagebreak()
= Authentication

Authentication is the process of proving you are who you claim to be (before being granted access to non-public resources).
It is distinct from _access control_, which concerns what exactly you can do, once authenticated.

Three general factors:
- What you *know*: private knowledge, e.g., PINs
- What you *have*: physical or cryptographic possessions, e.g. keys (mechanical or electronic), 2FA authenticators
- What you *are*: non-informational properties of the user, e.g. biometrics

== What you know -- Passwords

=== The Password Design Dilemma

A good password system must simultaneously satisfy contradictory requirements:
- easy to _memorize_, but hard to _guess_
- easy to _use_, but hard to be _stolen_
- easy to store _securely_, but also _retrievable_\*

\*Whether retrievability is desired is debatable :p

=== Password Storage

Naive plaintext
- storing (username, password) verbatim
- a data breach leaks everything

Hashed
- store (username, $H(#"password")$)
- on login: compute $H(#"entered password")$ and compare to stored hash
- assuming one-way hash function, data breach does not immediately reveal actual passwords
- problem: same password = same hash, enabling precomputed lookup tables (and the more space-efficient _rainbow tables_, which trade time for space via hash chains and reduction functions) to recover passwords after a breach

Salted hash
- store (username, $H(#"password" || #"salt")$, salt)
- salt is a random value
- now even same passwords produce different hashes, rendering rainbow tables useless (new table needed per-hash; increasing hash size makes this infeasible)
- modern best practice: use a _slow_ password-hashing KDF (Argon2, bcrypt, scrypt) so brute-force becomes prohibitively expensive even per-user

=== Hashed Password Attacks

/ Dictionary Attack: take wordlist, hash each on the fly, compare against password hash / search in list of hashes.

/ Rainbow table: dictionary attack but fully pre-computed. Usually uses a much larger dictionary for higher hit-rate.

Rainbow table with dictionary size $d$: hash $d$ strings... profit. \
With $x$-bit salt: now need to hash $d times 2^x$ string = salt combos... sad.

With a 32-bit salt, there are $~4 times 10^9$ possible salt values requiring as many rainbow tables. \
Salting defeats universal precomputation, significantly nerfing rainbow tables.
Dictionary attacks on a per-user basis still works.

A small (\~10) GPU cluster can perform $~10^11$ (SHA-512) hashes per second, making it possible to crack hashes (by exhausting dictionaries) on the hourly timescale.
(`bcrypt` is significantly slower, at $~10^6$/s.) \
Regardless of a slow hash function or not, by NOT choosing a password that could end up in a dictionary (e.g. pseudo-random strings), you get cracking-resistance for free.

== What you have -- Cryptographic Tokens

=== Challenge-Response Auth

Alice and Bob have a previously-established, persistent pair of symmetric keys.

Challenge procedure:
- Alice wants to authenticate with Bob
- Bob provides Alice a challenge, a random string
- Alice computes a MAC (or encryption) of the challenge under the shared key, sends back
- Bob recomputes/decrypts to verify

The challenge is random to prevent replay attacks. \
This can also be extended to happen both way for bidirectional auth.

=== One-Time Passwords (OTP)

...prevents replay attacks by definition.

*Hash-chain OTP (Lamport scheme)*:

Setup (server-side):
+ user generates random secret $w$
+ user computes $H^t (w)$ (hashes $t$ times) and sends to server
+ server stores value and stores counter $j = 0$

Authentication ($i$-th login)
+ user sends their name, $i$, and $H^(t-i) (w)$
+ server checks that $i = j + 1$ AND $H("submitted value") = "stored value"$
+ update stored value to submitted value and increment $j$

Pros:
- server does not store any secret; can be compromised and will be ok
Cons:
- you get exactly $t$ logins; need re-setup afterwards.
  (The $t$-th login reveals $w$ itself, so re-setup must precede running out.)

*Time-based OTP*:

shared secret + current universal time (bucketed into a few-second window) = temporally temporary codes. \
Requires clock synchronization. Not strictly _one-time_: the same code is reusable within its time window.

=== What You Are -- Biometrics

/ Biometric: A measurable property of an individual from which distinguishing and repeatable features can be extracted for automatic recognition.

- Distinguishing: reliable tell two different people apart
- Repeatable: reliably recognize the same person as, well, the same person (i.e. must produce consistent features across measurements)

*Two-Phase Process*:

+ Enrollment
  + capture multiple raw samples
  + extract digital feature template
  + store template
+ Authentication
  + capture new sample
  + extract features
  + compare to stored template (fuzzy match)

Problem: threshold for fuzzy? Too loose = insecure; too tight = many false lockouts.

*Modalities*:

#table(
  columns: 6,
  align: horizon,
  toprule(),

  [Modality], [Usability], [Maintainability], [Match\ Accuracy], [Feature\ Stability], [Notes],

  midrule(),

  [Fingerprint],
  [ok],
  [ok],
  [good],
  [good],
  [need to check for "liveness" to prevent amputation attacks; "gummy-bear" attacks possible],

  [Hand Scanner], [good], [good], [ok], [good], [hard to train the model],
  [Iris Scanner], [ok], [good], [good], [ok], [patterned/coloured contact lenses can cause issues],
  [Retina Scanner],
  [poor],
  [good],
  [excellent],
  [excellent],
  [invasive (NIR through pupil); rarely deployed outside high-security],

  bottomrule(),
)

Pros:
- nothing to remember
- passive, can't lose it
- cannot be shared or lent
- unique (assuming perfect accuracy and a suitable biometric)

Cons:
- revocation is impossible
- invasive: ties an authentication medium to an individual, uniquely
- not secret (e.g. fingerprints can be lifted)
- false acceptance: by nature of fuzzy... (recall birthday paradox)

More... \
Stored templates are a privacy risk \
Biometrics are implicit identification \
User confidence massively declines as soon as one attack succeeds

=== Multi-Factor Authentication (MFA)

// TODO: MFA details (combining factors; SMS-OTP weaknesses; FIDO2/WebAuthn; push fatigue)

=== Attacks

// TODO: phishing, replay, credential stuffing, password spraying, SIM swap, MFA fatigue, etc.


#pagebreak()
= Access Control

Authentication alone is insufficient -- not all users, even authenticated, should be granted access to _everything_. \
Authentication is a _coarse_ form of access control; it is a boolean check on your ability to access a system _at all_, whereas this is about _fine-grained_ access control.

== Core Model

#table(
  columns: (auto, 1fr),
  align: horizon,
  toprule(),
  table.header([Component], [Meaning]),
  midrule(),

  [Subjects (S)], [Users of the system (commonly modeled as _accounts_)],
  [Objects (O)], [Resources on the system (e.g. files)],
  [Access Rights (R)], [Extent of access (e.g. execute, read, write, append)],

  bottomrule(),
)

An access right can be characterized by two dimensions: _alteration_ and _observation_.

#table(
  columns: (auto, auto, auto),
  toprule(),

  [], [*no alteration*], [*alteration*],
  [*no observation*], [execute], [append],
  [*observation*], [read], [write],

  bottomrule(),
)

(This is an abstract model: "execute" assumes the runtime doesn't leak file contents to the subject, even though concrete OSes typically read the binary into the subject's memory.)

/ Reference Monitor: The component of a system that enforces access control decisions. (e.g. operating system, hotel staff)


== Access Control Matrix

A simple access control model.

...subjects as rows, objects as columns, and cells containing the corresponding access rights.

E.g.:

#table(
  columns: (auto, auto, auto, auto),
  toprule(),

  [], [`file1`], [`file2`], [`file3`],
  [*Alice*], [read, write], [], [read],
  [*Bob*], [], [read, write], [read, write],

  bottomrule(),
)

1. Subject requests to access and object
2. _Reference monitor_ looks in the matrix
3. Grant or deny access accordingly

Problem: access control matrices are not very space-efficient, requiring \#user $times$ \#files entries.

== Access Control List

Basically a sparse representation of an access control matrix.
A bit less inefficient. \
Each object stores a list of subjects who have rights (and the specific rights in question).

== UNIX Permissions

An implemented access control model with major industrial use.

Traditional UNIX permissions are an ACL-_like_ approach (not true ACLs — POSIX extended ACLs are a separate, later addition).
Each file only stores permissions for three generalized subjects:
- owner
- group
- world

The _owner_ refers to one specific, concrete subject (user). \
The _group_ refers to a predefined collection of subjects. \
The _world_ is any other subject that is neither the owner nor belongs to the group.

It is important to note that the "owner" just refers to some arbitrary user.
UNIX does not have _ownership_ semantics; that is, being the _owner_ does not semantically grant any additional permissions. \
(Owners do retain administrative privileges outside the rwx bits, e.g. `chmod` and `chown` to themselves, since these go through dedicated syscalls rather than the access matrix.)

The set of access rights (for any of these indirect subjects) are
- read (`r`)
- write (`w`)
- execute (`x`)

This results in a total of 9 boolean values, stored as 9 bits, and commonly represented as a 9-character string: [owner-r][owner-w][owner-x][group-r][group-w][group-x][world-r][world-w][world-x], where a corresponding character is '`-`' if that permission is denied. E.g.:\
- `rwxrwxrwx` : everyone has all permissions
- `rwx------` : owner has all permissions, everyone else has none.
- `---r-xr-x` : the "owner" has no permissions, but everyone else can read or execute.
- `rwx---rw-` : the owner has all permissions, the group has none, and everyone else can r/w.

The reference monitor checks a subject against the owner, group, and world permissions *in order*, and applies the first match. \
Hence, one can achieve _negative_ permissions; e.g. if the owner has less permissions than world.

For *directories*, "read", "write", and "execute" are not semantically intuitive:
- read = list contents of directory (allows `getdents(dir)` syscall)
- write = create, rename, or delete the contents, (_only_ in conjunction with execute)
- execute = "traverse" (allows the directory as a _path component_ to syscalls, e.g. `stat` on contents)

...then, there's also the interaction between read and execute for directories:
- read (no execute) = can list all files; names, but cannot `stat` them
- execute (no read) = semantic "dark read" access; can access files by direct path, but cannot list
- read _and_ execute = semantic "read" access; can discover and access contents (according to their permissions), but cannot create/rename/delete contents
- write (no execute) = does nothing; you need execute to do stuff like `touch dir/newfile`

/ Sticky Bit: The 10th UNIX permission value.
  When set on a directory, only the owner can rename or delete contents, even if others have write permission on the directory.
  This is useful for shared directories like `/tmp` where all users need `rwx` but shouldn't be able to delete each other's files.


*Root User*:
- default owner of all system files
- has all permissions regardless of the permission bits
- critical in multi-user systems, protecting users from themselves (messing up system) and each other

*`sudo`*:
- temporarily grants a user the privileges of another user (root by default)
- principle: don't run as root all the time; elevate only when needed


== Design Principles

- Least privilege: set permissions to minimum needed; don't make files globally readable by default.
- Separation of responsibilities: different roles get different permissions.
- Complete mediation: every file access goes through the reference monitor; no caching of permissions that could become stale.
- Fail-safe default: no permissions should mean deny by default
- Defense in depth: use other mechanisms in addition to e.g. UNIX system permissions
- Open design: reference monitor source should be auditable
- Psychological acceptability: Intuitive system
- Economy of mechanisms: Keep the TCB (below) small

== Trusted Computing Base (TCB)

/ Trusted Computing Base: (TCB) Every component (hardware or software) upon which the _security policy_ relies.
  If any TCB component is compromised, the security policy may be violated.

For access control, the TCB includes:
- TPM chip: hardware that verifies the integrity of low level software (bootloader, kernel) (_secure boot_)
- the kernel itself
- any `setuid` programs (below)

== Unix Processes & Privilege System

The system complementary to the UNIX Permissions model.

/ Process Isolation:
  - Processes cannot access each other's memory (by default)
  - Each process runs with the permissions of its associated _User_
  - A process can access any file its user has access to

Specifically, user accounts are identified by and represented as numeric IDs.

There are three User IDs (UIDs) for a process:
- Real UID (RUID): identifies who the process _belongs_ to
- Effective UID (EUID): what the reference monitor uses for permissions
- Saved UID (SSUID): used to store the value of the EUID before modification

All processes are spawned by a parent (except `init`); on process creation:
- RUID is inherited from parent's RUID
- EUID is inherited from parent's EUID, or set to file's owner if `setuid` bit is set (see below)
- SSUID is set to the same as EUID

NOTE that the above is `exec*` syscalls; `fork` copies UIDs unconditionally.

Changing UIDs:
- Root:
  - `setuid(x)`: changes all 3 to x
  - `seteuid(x)`: changes EUID to x
- Unprivileged users:
  - `setuid(x)`: changes EUID to x only if x is RUID or SSUID (or EUID)
  - `seteuid(x)`: same as `setuid`

=== Elevating Privileges (`setuid` bit)

Unprivileged users often need _elevation_ for specific operations (e.g. `passwd` modifies `/etc/shadow`, which only root can r/w). \
The setuid permission bit (the 12th bit) on an executable file means when the file is executed, the process's EUID (and SSUID) is set to the file's owner rather than inheriting the parent's (default).

(The setgid bit is the 11th bit, and works similarly but for groups instead of users.)

Pros of UNIX model:
- simple
- flexible enough for most access control policies

Cons:
- ACLs are coarse-grained (only 3 subjects)
- cannot differentiate between processes run by the same user; you cannot have different processes have different permissions without running them as different users
- nearly all system operations require root, creating a large attack surface

== Access Control Policy Types

Mandatory Access Control
- Central authority determines access
- Even if you "own" a file, you cannot grant access to someone else unless the system policy allows it, the discretion is taken away from the user
- Very secure at the cost of being rigid and difficult to manage/configure

Discretionary Access Control
- Access is at the discretion of the owner, if you create it, you own it, and decide who else can touch it
- \*nix style
- Prone to user error as the system won't enforce anything (can make sensitive file world-readable)

Role-Based Access Control
- Permissions are tied to roles ("Manager", "HR", or "SysAdmin" rather than User IDs)
- May implement MAC or DAC

== Graham-Denning Model

/ Graham-Denning Model: A formal access control model defining 8 _operations_ on an access control matrix to characterize how it evolves over time.

Below, $X$'s (and $S$'s) are subjects, $O$'s are objects, and $R$'s are access rights. \
A right $R$ can additionally be marked as "transferable", denoted $R^*$. \
"_A_ only if $(...)$" means _A_ can only be performed if the right represented by the tuple is in the reference monitor's database (access control matrix). \
Similarly, "_A_ generates $(...)$" means _A_ creates the corresponding entry in the access control matrix. \
$(A, B, R)$ means subject $A$ has right $R$ ("owner" or "control") on subject/object $B$.

$X$ creating $O$ generates $(X, O, #quote[owner])$. \
$X$ can delete $O$ only if $(X, O, #quote[owner])$.

$X$ creating $S$ generates $(X, S, #quote[owner])$ AND $(X, S, #quote[control])$. \
$X$ can delete $S$ only if $(X, S, #quote[owner])$.

$X$ can grant $R$ or $R^*$ on $O$ to $S$ only if $(X, O, #quote[owner])$. \
$X$ can transfer $R$ or $R^*$ on $O$ to $S$ only if $(X, O, R^*)$.

$X$ can revoke $R$ on $O$ from $S$ only if $(X, O, #quote[owner])$ OR $(X, S, #quote[control])$. \
$X$ can read rights on $O$ for $S$ only if $(X, O, #quote[owner])$ OR $(X, S, #quote[control])$.

Note that the "subject" (item \#2) of a table entry can be _either_ a subject or an object.

*Grant vs. Transfer*: only #emph[owner]s can grant rights, whereas any holder of a _transferable_ right ($R^*$) can transfer it.
Note that $X$ retains $R^*$ even after "transferring" it.

== Access Control in Organizations

Idea: effective access problem in practice, especially in larger organizations, is difficult.

Correctness requirements:
- no gaps: every resource must be covered by policy
- no conflicts
- no unintended restrictions: _primary goals_ must not be impeded

Logistical challenges:
- Information asymmetry (between different employees): e.g. security admins not knowing someone was fired
  - Insider attacks often result from the failure to revoke access of former employees
- Efficient updates: people's roles change, and access needs to be kept up-to-date

== Modern Models

Android has a unique and effective access control / security model:

- per-application (per-user) permissions (e.g. GPS access in a mobile app): higher granularity
- runs SELinux which enforces MAC over all processes (every process runs as unique user)
- uses per-app sandboxing: apps cannot access outside its own data by default
- runs the user as non-root by default (and in fact never grants the user root)


#pagebreak()
= Security Examples

// TODO: case studies / worked examples

