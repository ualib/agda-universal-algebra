---
layout: default
title : Birkhoff.FreeAlgebra (The Agda Universal Algebra Library)
date : 2021-01-14
author: William DeMeo
---

### <a id="the-free-algebra">The Free Algebra</a>

This section presents the [Birkhoff.FreeAlgebra][] module of the [Agda Universal Algebra Library][].

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import Algebras.Signatures using (Signature; 𝓞; 𝓥)
open import MGS-Subsingleton-Theorems using (global-dfunext)

module Birkhoff.FreeAlgebra {𝑆 : Signature 𝓞 𝓥}{gfe : global-dfunext} where

open import Varieties.Preservation {𝑆 = 𝑆}{gfe} public

\end{code}


#### <a id="the-free-algebra-in-theory">The free algebra in theory</a>

Recall, we proved in [the universal property](Terms.Basic.html#the-universal-property) section of the [Terms.Basic][] module that the term algebra `𝑻 X` is the absolutely free algebra in the class of all `𝑆`-structures. In this section, we formalize, for a given class `𝒦` of `𝑆`-algebras, the (relatively) free algebra in `S(P 𝒦)` over `X`.

We use the next definition to take a free algebra *for* a class `𝒦` and produce the free algebra *in* `𝒦`.

`Θ(𝒦, 𝑨) := {θ ∈ Con 𝑨 : 𝑨 / θ ∈ (S 𝒦)}` &nbsp; &nbsp; and &nbsp; &nbsp; `ψ(𝒦, 𝑨) := ⋂ Θ(𝒦, 𝑨)`.

Notice that `Θ(𝒦, 𝑨)` may be empty, in which case `ψ(𝒦, 𝑨) = 1` and then `𝑨 / ψ(𝒦, 𝑨)` is trivial.

The free algebra is constructed by applying the above definitions to the special case in which `𝑨` is the term algebra `𝑻 X` of `𝑆`-terms over `X`.

Since `𝑻 X` is free for (and in) the class of all `𝑆`-algebras, it follows that `𝑻 X` is free for every class `𝒦` of `𝑆`-algebras. Of course, `𝑻 X` is not necessarily a member of `𝒦`, but if we form the quotient of `𝑻 X` modulo the congruence `ψ(𝒦, 𝑻 X)`, which we denote by `𝔉 := (𝑻 X) / ψ(𝒦, 𝑻 X)`, then it's not hard to see that `𝔉` is a subdirect product of the algebras in `{(𝑻 𝑋) / θ}`, where `θ` ranges over `Θ(𝒦, 𝑻 X)`, so `𝔉` belongs to `S(P 𝒦)`, and it follows that `𝔉` satisfies all the identities satisfied by all members of `𝒦`.  Indeed, for each pair `p q : 𝑻 X`, if `𝒦 ⊧ p ≈ q`, then `p` and `q` must belong to the same `ψ(𝒦, 𝑻 X)`-class, so `p` and `q` are identified in the quotient `𝔉`.

The `𝔉` that we have just defined is called the **free algebra over** `𝒦` **generated by** `X` and (because of what we just observed) we may say that `𝔉` is free *in* `S(P 𝒦)`.<sup>[1](Birkhoff.FreeAlgebra.html#fn1)</sup>

#### <a id="the-free-algebra-in-agda">The free algebra in Agda</a>

Here we represent `𝔉` as a type in Agda by first constructing the congruence `ψ(𝒦, 𝑻 𝑋)` described above.

We assume two ambient universes `𝓤` and `𝓧`, as well as a type `X : 𝓧 ̇`. As usual, this is accomplished with the `module` directive.

\begin{code}

module the-free-algebra {𝓤 𝓧 : Universe}{X : 𝓧 ̇} where

 -- NOTATION (universe aliases for convenience and readability).
 𝓸𝓿𝓾 𝓸𝓿𝓾+ 𝓸𝓿𝓾++ : Universe
 𝓸𝓿𝓾 = ov 𝓤
 𝓸𝓿𝓾+ = 𝓸𝓿𝓾 ⁺
 𝓸𝓿𝓾++ = 𝓸𝓿𝓾 ⁺ ⁺

\end{code}

We first construct the congruence relation `ψCon`, modulo which `𝑻 X` yields the relatively free algebra, `𝔉 𝒦 X := 𝑻 X ╱ ψCon`. We start by letting `ψ` be the collection of identities `(p, q)` satisfied by all subalgebras of algebras in `𝒦`.

\begin{code}

 ψ : (𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾) → Pred (∣ 𝑻 X ∣ × ∣ 𝑻 X ∣) (𝓧 ⊔ 𝓸𝓿𝓾)
 ψ 𝒦 (p , q) = ∀(𝑨 : Algebra 𝓤 𝑆)(sA : 𝑨 ∈ S{𝓤}{𝓤} 𝒦)(h : X → ∣ 𝑨 ∣ )
                →  (free-lift 𝑨 h) p ≡ (free-lift 𝑨 h) q

\end{code}

We convert the predicate ψ into a relation by [currying](https://en.wikipedia.org/wiki/Currying).

\begin{code}

 ψRel : (𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾) → Rel ∣ 𝑻 X ∣ (𝓧 ⊔ 𝓸𝓿𝓾)
 ψRel 𝒦 p q = ψ 𝒦 (p , q)

\end{code}

To express `ψRel` as a congruence of the term algebra `𝑻 X`, we must prove that

1. `ψRel` is compatible with the operations of `𝑻 X` (which are jsut the terms themselves) and
2. `ψRel` it is an equivalence relation.

\begin{code}

 ψcompatible : (𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾) → compatible (𝑻 X)(ψRel 𝒦)
 ψcompatible 𝒦 f {i} {j} iψj 𝑨 sA h = γ
  where
   ϕ : hom (𝑻 X) 𝑨
   ϕ = lift-hom 𝑨 h

   γ : ∣ ϕ ∣ ((f ̂ 𝑻 X) i) ≡ ∣ ϕ ∣ ((f ̂ 𝑻 X) j)
   γ = ∣ ϕ ∣ ((f ̂ 𝑻 X) i) ≡⟨ ∥ ϕ ∥ f i ⟩
       (f ̂ 𝑨) (∣ ϕ ∣ ∘ i) ≡⟨ ap (f ̂ 𝑨) (gfe λ x → ((iψj x) 𝑨 sA h)) ⟩
       (f ̂ 𝑨) (∣ ϕ ∣ ∘ j) ≡⟨ (∥ ϕ ∥ f j)⁻¹ ⟩
       ∣ ϕ ∣ ((f ̂ 𝑻 X) j) ∎

 ψRefl : {𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾} → reflexive (ψRel 𝒦)
 ψRefl = λ _ _ _ _ → 𝓇ℯ𝒻𝓁

 ψSymm : {𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾} → symmetric (ψRel 𝒦)
 ψSymm _ _ pψRelq 𝑪 ϕ h = (pψRelq 𝑪 ϕ h)⁻¹

 ψTrans : {𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾} → transitive (ψRel 𝒦)
 ψTrans _ _ _ pψq qψr 𝑪 ϕ h = (pψq 𝑪 ϕ h) ∙ (qψr 𝑪 ϕ h)

 ψIsEquivalence : {𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾} → IsEquivalence (ψRel 𝒦)
 ψIsEquivalence = record { rfl = ψRefl ; sym = ψSymm ; trans = ψTrans }

\end{code}

We have collected all the pieces necessary to express the collection of identities satisfied by all subalgebras of algebras in the class as a congruence relation of the term algebra. We call this congruence `ψCon` and define it using the Congruence constructor `mkcon`.

\begin{code}

 ψCon : (𝒦 : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾) → Congruence (𝑻 X)
 ψCon 𝒦 = mkcon (ψRel 𝒦) (ψcompatible 𝒦) ψIsEquivalence

\end{code}


Finally, we are ready to define the type representing the relatively free algebra in Agda.  We denote this type by 𝔉 and define it as the quotient `𝑻 X ╱ (ψCon 𝒦)`.

\begin{code}

module the-relatively-free-algebra
 {𝓤 𝓧 : Universe}{X : 𝓧 ̇} {𝒦 : Pred (Algebra 𝓤 𝑆) (ov 𝓤)} where

 open the-free-algebra{𝓤 = 𝓤}{𝓧 = 𝓧}{X = X}

 𝓕 : Universe -- (universe level of the relatively free algebra)
 𝓕 = (𝓧 ⊔ ov 𝓤) ⁺

 𝔉 : Algebra 𝓕 𝑆
 𝔉 =  𝑻 X ╱ (ψCon 𝒦)

\end{code}

The domain ∣ 𝔉 ∣ is

`∣ 𝑻 X ∣ / ⟨ ψCon 𝒦 ⟩ = Σ C ꞉ _ ,  Σ p ꞉ ∣ 𝑻 X ∣ ,  C ≡ ( [ p ] ⟨ ψCon 𝒦 ⟩ )`,

which is the collection `{ C : ∃ p ∈ ∣ 𝑻 X ∣, C ≡ [ p ]⟨ ψCon 𝒦 ⟩ }` of `⟨ ψCon 𝒦 ⟩`-classses of `𝑻 X`, as desired.

<!--

---------------------------

#### Old unused stuff


One could define the collection `𝑻img` of all homomorphic images of the term algebra that belong to a given class 𝒦 as follows.

 -- H (𝑻 X)  (hom images of 𝑻 X)
 𝑻img : Pred (Algebra 𝓤 𝑆) 𝓸𝓿𝓾 → 𝓸𝓿𝓾 ⊔ 𝓧 ⁺ ̇
 𝑻img 𝒦 = Σ 𝑨 ꞉ (Algebra 𝓤 𝑆) , Σ ϕ ꞉ hom (𝑻 X) 𝑨 , (𝑨 ∈ 𝒦) × Epic ∣ ϕ ∣

The inhabitants of this Sigma type represent algebras 𝑨 ∈ 𝒦 such that there exists a surjective homomorphism ϕ : hom (𝑻 X) 𝑨. Thus, 𝑻img represents the collection of all homomorphic images of 𝑻 X that belong to 𝒦.  Of course, this is the entire class 𝒦, since the term algebra is absolutely free. Nonetheless, this representation of 𝒦 is useful since it endows each element with extra information.  Indeed, each inhabitant of 𝑻img 𝒦 is a quadruple, (𝑨 , ϕ , ka, p), where 𝑨 is an 𝑆-algebra, ϕ is a homomorphism from 𝑻 X to 𝑨, ka is a proof that 𝑨 belongs to 𝒦, and p is a proof that the underlying map ∣ ϕ ∣ is epic.

The next function, `mkti`, that takes an arbitrary algebra 𝑨 in 𝒦 and a mapping X → ∣ 𝑨 ∣ and returns the corresponding quadruple in `𝑻img 𝒦`.

 mkti : {𝒦 : Pred (Algebra 𝓤 𝑆)𝓸𝓿𝓾}(𝑨 : Algebra 𝓤 𝑆)(h : X → ∣ 𝑨 ∣) → Epic h → 𝑨 ∈ 𝒦 → 𝑻img 𝒦
 mkti 𝑨 h hE ka = (𝑨 , lift-hom 𝑨 h , ka , lift-of-epi-is-epi hE)

-->
----------------------------





<span class="footnote" id="fn1"><sup>1</sup>Since `X` is not a subset of `𝔉`, technically it doesn't make sense to say "`X` generates `𝔉`." But as long as 𝒦 contains a nontrivial algebra, we will have `ψ(𝒦, 𝑻 𝑋) ∩ X² ≠ ∅`, and we can identify `X` with `X / ψ(𝒦, 𝑻 X)` which does belong to 𝔉.</span>

[↑ Birkhoff](Birkhoff.html)
<span style="float:right;">[Birkhoff.HSPTheorem →](Birkhoff.HSPTheorem.html)</span>

{% include UALib.Links.md %}

<!--

Lemma 4.27. (Bergman) Let 𝒦 be a class of algebras, and ψCon defined as above.
                     Then 𝔽 := 𝑻 / ψCon is isomorphic to an algebra in SP(𝒦).

Proof. 𝔽 ↪ ⨅ 𝒜, where 𝒜 = {𝑨 / θ : 𝑨 / θ ∈ S 𝒦}.
       Therefore, 𝔽 ≅ 𝑩, where 𝑩 is a subalgebra of ⨅ 𝒜 ∈ PS(𝒦).
       Thus 𝔽 is isomorphic to an algebra in SPS(𝒦).
       By SPS⊆SP, 𝔽 is isomorphic to an algebra in SP(𝒦).

-->



