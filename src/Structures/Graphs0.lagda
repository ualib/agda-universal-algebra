---
layout: default
title : Structures.Graphs0
date : 2021-06-22
author: [agda-algebras development team][]
---

## <a id="graph-structures-again">Graph Structures (again)</a>

This is the [Structures.Graphs0][] module of the [Agda Universal Algebra Library][].

N.B. This module differs from Graphs.lagda in that here we assume some universes are level zero (i.e., ℓ₀). This simplifies some things; e.g., we avoid having to use lift and lower (cf. Graphs.lagda)

Definition [Graph of a structure]. Let 𝑨 be an (𝑅,𝐹)-structure (relations from 𝑅 and operations from 𝐹).
The *graph* of 𝑨 is the structure Gr 𝑨 with the same domain as 𝑨 with relations from 𝑅 and together with a (k+1)-ary relation symbol G 𝑓 for each 𝑓 ∈ 𝐹 of arity k, which is interpreted in Gr 𝑨 as all tuples (t , y) ∈ Aᵏ⁺¹ such that 𝑓 t ≡ y. (See also Definition 2 of https://arxiv.org/pdf/2010.04958v2.pdf)


\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

module Structures.Graphs0 where

-- Imports from Agda and the Agda Standard Library -------------------------------------------
open import Agda.Primitive using ( _⊔_ ; Level ) renaming ( Set to Type ; lzero to ℓ₀ )
open import Data.Product   using ( _,_ ; _×_ ; Σ-syntax )
open import Data.Sum.Base  using ( _⊎_ ) renaming ( inj₁ to inl ; inj₂ to inr )
open import Data.Fin.Base  using ( Fin )
open import Data.Nat       using ( ℕ )
open import Function.Base  using ( _∘_ )
open import Relation.Unary using ( Pred ; _∈_ )
open import Relation.Binary.PropositionalEquality
                           using ( _≡_ ; module ≡-Reasoning ; cong ; sym ; refl )

-- Imports from the Agda Universal Algebra Library ---------------------------------------------
open import Overture.Preliminaries using ( 𝟙 ; ∣_∣ ; ∥_∥ )
open import Relations.Continuous   using ( Rel )
open import Structures.Basic       using ( signature ; structure )
open import Examples.Structures.Signatures
                                   using ( S∅ )
open import Structures.Homs        using ( hom ; is-hom-rel ; is-hom-op )


open signature
open structure
open _⊎_

Gr-sig : signature ℓ₀ ℓ₀ → signature ℓ₀ ℓ₀ → signature ℓ₀ ℓ₀

Gr-sig 𝐹 𝑅 = record { symbol = symbol 𝑅 ⊎ symbol 𝐹
                    ; arity  = ar }
 where
 ar : symbol 𝑅 ⊎ symbol 𝐹 → Type ℓ₀
 ar (inl 𝑟) = (arity 𝑅) 𝑟
 ar (inr 𝑓) = (arity 𝐹) 𝑓 ⊎ 𝟙


private variable
 𝐹 𝑅 : signature ℓ₀ ℓ₀

Gr : structure 𝐹 𝑅 {ℓ₀} {ℓ₀} → structure S∅ (Gr-sig 𝐹 𝑅) {ℓ₀} {ℓ₀}
Gr {𝐹}{𝑅} 𝑨 = record { carrier = carrier 𝑨 ; op = λ () ; rel = split }
  where
  split : (s : symbol 𝑅 ⊎ symbol 𝐹) → Rel (carrier 𝑨) (arity (Gr-sig 𝐹 𝑅) s) {ℓ₀}
  split (inl 𝑟) arg = rel 𝑨 𝑟 arg
  split (inr 𝑓) args = op 𝑨 𝑓 (args ∘ inl) ≡ args (inr 𝟙.𝟎)


open ≡-Reasoning

module _ {𝑨 𝑩 : structure 𝐹 𝑅 {ℓ₀}{ℓ₀}} where

 hom→Grhom : hom 𝑨 𝑩 → hom (Gr 𝑨) (Gr 𝑩)
 hom→Grhom (h , hhom) = h , (i , ii)
  where
  i : is-hom-rel (Gr 𝑨) (Gr 𝑩) h
  i (inl 𝑟) a x = ∣ hhom ∣ 𝑟 a x
  i (inr 𝑓) a x = goal
   where
   homop : h (op 𝑨 𝑓 (a ∘ inl)) ≡ op 𝑩 𝑓 (h ∘ (a ∘ inl))
   homop = ∥ hhom ∥ 𝑓 (a ∘ inl)

   goal : op 𝑩 𝑓 (h ∘ (a ∘ inl)) ≡ h (a (inr 𝟙.𝟎))
   goal = op 𝑩 𝑓 (h ∘ (a ∘ inl)) ≡⟨ sym homop ⟩
          h (op 𝑨 𝑓 (a ∘ inl))   ≡⟨ cong h x ⟩
          h (a (inr 𝟙.𝟎))         ∎

  ii : is-hom-op (Gr 𝑨) (Gr 𝑩) h
  ii = λ ()


 Grhom→hom : hom (Gr 𝑨) (Gr 𝑩) → hom 𝑨 𝑩
 Grhom→hom (h , hhom) = h , (i , ii)
  where
  i : is-hom-rel 𝑨 𝑩 h
  i R a x = ∣ hhom ∣ (inl R) a x
  ii : is-hom-op 𝑨 𝑩 h
  ii f a = goal
   where
   split : arity 𝐹 f ⊎ 𝟙 → carrier 𝑨
   split (inl x) = a x
   split (inr y) = op 𝑨 f a
   goal : h (op 𝑨 f a) ≡ op 𝑩 f (λ x → h (a x))
   goal = sym (∣ hhom ∣ (inr f) split refl)

\end{code}

{- Lemma III.1. Let S be a signature and A be an S-structure.
Let Σ be a finite set of identities such that A ⊧ Σ. For every
instance X of CSP(A), one can compute in polynomial time an
instance Y of CSP(A) such that Y ⊧ Σ and | Hom(X , A)| = |Hom(Y , A)|.

Proof. ∀ s ≈ t in ℰ and each tuple b such that 𝑩 ⟦ s ⟧ b ≢ 𝑩 ⟦ t ⟧ b, one can compute
the congruence θ = Cg (𝑩 ⟦ s ⟧ b , 𝑩 ⟦ t ⟧ b) generated by 𝑩 ⟦ s ⟧ b and 𝑩 ⟦ t ⟧ b.
Let 𝑩₁ := 𝑩 / θ , and note that | 𝑩₁ | < | 𝑩 |.

We show ∃ a bijection from hom 𝑩 𝑨 to hom 𝑩₁ 𝑨.
Fix an h : hom 𝑩 𝑨.
∀ s ≈ t in ℰ, we have h (𝑩 ⟦ s ⟧ b) = 𝑨 ⟦ s ⟧ (h b) = 𝑨 ⟦ t ⟧ (h b) = h (𝑩 ⟦ t ⟧ b).

Therefore, θ ⊆ ker h, so h factors uniquely as h = h' ∘ π : 𝑩 → (𝑩 / θ) → 𝑨,
where π is the canonical projection onto 𝑩 / θ.
Thus the mapping φ : hom 𝑩 𝑨 → hom 𝑩₁ 𝑨 that takes each h to h' such that h = h' ∘ π
is injective.  It is also surjective since each g' : 𝑩 / θ → 𝑨 is mapped back to
a g : 𝑩 → 𝑨 such that g = g' ∘ π. Iterating over all identities in ℰ, possibly
several times, at the final step we obtain a structure 𝑩ₙ that satisfies ℰ
and is such that ∣ hom 𝑩 𝑨 ∣ = ∣ hom 𝑩ₙ 𝑨 ∣. Moreover, since the number of elements
in the intermediate structures decreases at each step, | 𝑩ᵢ₊₁ | < | 𝑩ᵢ |, the process
finishes in time that is bounded by a polynomial in the size of 𝑩.
-}


\begin{code}

record _⇛_⇚_ (𝑩 𝑨 𝑪 : structure 𝐹 𝑅) : Type ℓ₀ where
 field
  to   : hom 𝑩 𝑨 → hom 𝑪 𝑨
  from : hom 𝑪 𝑨 → hom 𝑩 𝑨
  to∼from : ∀ h → (to ∘ from) h ≡ h
  from∼to : ∀ h → (from ∘ to) h ≡ h


module _ {χ : Level}{X : Type χ}
         {𝑨 : structure 𝐹 𝑅 {ℓ₀} {ℓ₀}} where

 -- TODO: formalize Lemma III.1

 -- LEMMAIII1 : {n : ℕ}(ℰ : Fin n → (Term X × Term X))(𝑨 ∈ fMod ℰ)
 --  →          ∀(𝑩 : structure 𝐹 𝑅) → Σ[ 𝑪 ∈ structure 𝐹 𝑅 ] (𝑪 ∈ fMod ℰ × (𝑩 ⇛ 𝑨 ⇚ 𝑪))
 -- LEMMAIII1 ℰ 𝑨⊧ℰ 𝑩 = {!!} , {!!}

\end{code}


--------------------------------

<span style="float:left;">[← Structures.Graphs](Structures.Graphs.html)</span>
<span style="float:right;">[Structures.Products →](Structures.Products.html)</span>

{% include UALib.Links.md %}

[agda-algebras development team]: https://github.com/ualib/agda-algebras#the-agda-algebras-development-team

