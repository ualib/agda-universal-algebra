---
layout: default
title : UALib.Terms.Basic module (The Agda Universal Algebra Library)
date : 2021-01-14
author: William DeMeo
---

### <a id="basic-definitions">Basic definitions</a>

This section presents the [UALib.Terms.Basic][] module of the [Agda Universal Algebra Library][].

The theoretical background that begins each subsection below is based on Cliff Bergman's textbook [Bergman (2012)][], specifically, Section 4.3.  Apart from notation, our presentation is similar to Bergman's, but we will be more concise, omitting some details and all examples, in order to more quickly arrive at our objective, which is to use type theory to express the concepts and formalize them in the [Agda][] language.  We refer the reader to [Bergman (2012)][] for a more complete exposition of classical (informal) universal algebra.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import UALib.Algebras using (Signature; 𝓞; 𝓥; Algebra; _↠_)
open import UALib.Prelude.Preliminaries using (global-dfunext; Universe; _̇)

module UALib.Terms.Basic {𝑆 : Signature 𝓞 𝓥} {gfe : global-dfunext} where

open import UALib.Homomorphisms.HomomorphicImages{𝑆 = 𝑆}{gfe} hiding (Universe; _̇; Algebra) public

\end{code}

#### <a id="the-type-of-terms">The type of terms</a>

Fix a signature 𝑆 and let X denote a collection of variable symbols. Assume the symbols in X are distinct from the operation symbols of 𝑆, that is X ∩ ∣ 𝑆 ∣ = ∅.

By a **word** in the language of X ∪ ∣ 𝑆 ∣, we mean a nonempty, finite sequence of members of X ∪ ∣ 𝑆 ∣. We denote the concatenation of such sequences by simple juxtaposition.

Let 𝐹₀ denote the set of nullary operation symbols of 𝑆. We define by induction on 𝑛 the sets 𝑇ₙ of **words on** 𝑋 ∪ ∣ 𝑆 ∣ as follows (cf. [Bergman (2012)][] Def. 4.19):

𝑇₀ := X ∪ 𝐹₀;

𝑇ₙ₊₁ := 𝑇ₙ ∪ { 𝑓 s |  𝑓 : ∣ 𝑆 ∣ ,  s : ∥ 𝑆 ∥ 𝑓 → 𝑇ₙ },

and we define the collection of **terms in the signature** 𝑆 **over** X by 𝑇 X := ⋃<sub>{n < ω}</sub>𝑇ₙ.

By an 𝑆-**term** we mean a term in the signature 𝑆 over some collection of variable symbols.

The definition of 𝑇 X is recursive, indicating that the semantic notion of terms could be implemented in type theory as an inductive type. We confirm this by defining the following inductive type of terms.

\begin{code}

data Term {𝓧 : Universe}(X : 𝓧 ̇) : ov 𝓧 ̇  where
  generator : X → Term X
  node : (f : ∣ 𝑆 ∣)(args : ∥ 𝑆 ∥ f → Term X) → Term X

open Term

\end{code}

Here, the type `X : 𝓧 ̇` represents an arbitrary collection of variable symbols.

#### <a id="the-term-algebra">The term algebra</a>

For a given signature 𝑆, if the type `Term X` is nonempty (equivalently, X or 𝑆 is nonempty; i.e., there exist inhabitants x : X or s : 𝑆), then we can define an algebraic structure, denoted 𝑻 X, called the **term algebra in the signature** 𝑆 **over** X.  Terms are viewed as acting on other terms, so the domain and the basic operations are the terms themselves.

* For each operation symbol 𝑓 : ∣ 𝑆 ∣, denote by 𝑓 ̂ (𝑻 X) the operation on `Term X` which maps each tuple 𝒔 : ∥ 𝑆 ∥ 𝑓 → ∣ 𝑻 X ∣ to the formal term 𝑓 𝒔.

* Define 𝑻 X to be the algebra with universe `∣ 𝑻 X ∣ := Term X` and operations 𝑓 ̂ (𝑻 X), one for each symbol 𝑓 in ∣ 𝑆 ∣.

In [Agda][] the term algebra can be defined as simply as one would hope.

\begin{code}

--The term algebra 𝑻 X.
𝑻 : {𝓧 : Universe}(X : 𝓧 ̇) → Algebra (ov 𝓧) 𝑆
𝑻 X = Term X , node

\end{code}



#### <a id="the-universal-property">The universal property</a>

The term algebra 𝑻 X is *absolutely free*, or *universal*, for algebras in the signature 𝑆. That is, for every 𝑆-algebra 𝑨,

1.  every map `h : 𝑋 → ∣ 𝑨 ∣` lifts to a homomorphism from `𝑻 X` to 𝑨, and
2.  the induced homomorphism is unique.

We prove this in [Agda][] as follows.

\begin{code}

--1.a. Every map from X to ∣ 𝑨 ∣ lifts to a map from ∣ 𝑻 X ∣ to ∣ 𝑨 ∣.

free-lift : {𝓧 𝓤 : Universe}{X : 𝓧 ̇}(𝑨 : Algebra 𝓤 𝑆)(h : X → ∣ 𝑨 ∣) → ∣ 𝑻 X ∣ → ∣ 𝑨 ∣

free-lift _ h (generator x) = h x
free-lift 𝑨 h (node f args) = (f ̂ 𝑨) λ i → free-lift 𝑨 h (args i)


--1.b. The lift is a homomorphism.

lift-hom : {𝓧 𝓤 : Universe}{X : 𝓧 ̇}(𝑨 : Algebra 𝓤 𝑆) → (X → ∣ 𝑨 ∣) → hom (𝑻 X) 𝑨

lift-hom 𝑨 h = free-lift 𝑨 h , λ f a → ap (_ ̂ 𝑨) 𝓇ℯ𝒻𝓁


--2. The resulting homomorphism is unique.
free-unique : {𝓧 𝓤 : Universe}{X : 𝓧 ̇} → funext 𝓥 𝓤
 →            (𝑨 : Algebra 𝓤 𝑆)(g h : hom (𝑻 X) 𝑨)
 →            (∀ x → ∣ g ∣ (generator x) ≡ ∣ h ∣ (generator x))
 →            (t : Term X)
              ---------------
 →            ∣ g ∣ t ≡ ∣ h ∣ t

free-unique _ _ _ _ p (generator x) = p x

free-unique fe 𝑨 g h p (node f args) = ∣ g ∣ (node f args)            ≡⟨ ∥ g ∥ f args ⟩
                                       (f ̂ 𝑨)(λ i → ∣ g ∣ (args i))  ≡⟨ ap (_ ̂ 𝑨) γ ⟩
                                       (f ̂ 𝑨)(λ i → ∣ h ∣ (args i))  ≡⟨ (∥ h ∥ f args)⁻¹ ⟩
                                       ∣ h ∣ (node f args)             ∎
 where γ = fe λ i → free-unique fe 𝑨 g h p (args i)

\end{code}

Since it's absolutely free, 𝑻 X is the domain of a homomorphism to any algebra we like. Moreover, if we are given a surjective mapping h from X onto an algebra 𝑨, then the homomorphism constructed with `lift-hom 𝑨 h` will be an epimorphism from 𝑻 X onto 𝑨.  We formalize this observation now, along with the trivial fact that the lift induced by `h₀` agrees with `h₀` on `X`.

\begin{code}

module _ {𝓧 𝓤 : Universe}{X : 𝓧 ̇} where

 lift-agrees-on-X : (𝑨 : Algebra 𝓤 𝑆)(h₀ : X → ∣ 𝑨 ∣)(x : X) → h₀ x ≡ ∣ lift-hom 𝑨 h₀ ∣ (generator x)
 lift-agrees-on-X _ h₀ x = 𝓇ℯ𝒻𝓁

 lift-of-epi-is-epi : (𝑨 : Algebra 𝓤 𝑆)(h₀ : X → ∣ 𝑨 ∣) → Epic h₀ → Epic ∣ lift-hom 𝑨 h₀ ∣
 lift-of-epi-is-epi 𝑨 h₀ hE y = γ
  where
   h₀pre : Image h₀ ∋ y
   h₀pre = hE y

   h₀⁻¹y : X
   h₀⁻¹y = Inv h₀ y (hE y)

   η : y ≡ ∣ lift-hom 𝑨 h₀ ∣ (generator h₀⁻¹y)
   η =
    y                                 ≡⟨ (InvIsInv h₀ y h₀pre)⁻¹ ⟩
    h₀ h₀⁻¹y                          ≡⟨ lift-agrees-on-X 𝑨 h₀ h₀⁻¹y ⟩
    ∣ lift-hom 𝑨 h₀ ∣ (generator h₀⁻¹y) ∎

   γ : Image ∣ lift-hom 𝑨 h₀ ∣ ∋ y
   γ = eq y (generator h₀⁻¹y) η

\end{code}


(The `𝑻img` and `mkti` functions of the [UALib.Varieties.FreeAlgebra][] show how to construct such epimorphisms using the 𝕏, lift-hom, and lift-of-epi-is-epi functions.)




--------------------------------------

[↑ UALib.Terms](UALib.Terms.html)
<span style="float:right;">[UALib.Terms.Operations →](UALib.Terms.Operations.html)</span>

{% include UALib.Links.md %}
