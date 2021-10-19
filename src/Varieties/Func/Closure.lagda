---
layout: default
title : "Varieties.Func.Closure module (The Agda Universal Algebra Library)"
date : "2021-01-14"
author: "agda-algebras development team"
---

#### <a id="closure-operators-for-setoid-algebras">Closure Operators for Setoid Algebras</a>

Fix a signature 𝑆, let 𝒦 be a class of 𝑆-algebras, and define

* H 𝒦 = algebras isomorphic to a homomorphic image of a members of 𝒦;
* S 𝒦 = algebras isomorphic to a subalgebra of a member of 𝒦;
* P 𝒦 = algebras isomorphic to a product of members of 𝒦.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import Algebras.Basic using ( 𝓞 ; 𝓥 ; Signature )

module Varieties.Func.Closure {𝑆 : Signature 𝓞 𝓥} where

-- imports from Agda and the Agda Standard Library -------------------------------------------
open import Agda.Primitive        using ( _⊔_ ; lsuc ) renaming ( Set to Type )
open import Data.Product          using ( _,_ ; Σ-syntax ) renaming ( _×_ to _∧_ )
open import Data.Unit.Polymorphic using ( ⊤ ; tt )
open import Function.Bundles      using ( Func )
open import Function.Base         using ( id )
open import Level                 using ( Level ; Lift ; lift ; lower )
open import Relation.Binary       using ( Setoid )
open import Relation.Unary        using ( Pred ; _∈_ ; _⊆_ )

-- Imports from the Agda Universal Algebra Library ---------------------------------------------
open import Algebras.Func.Basic                  {𝑆 = 𝑆} using ( SetoidAlgebra ; ov ; Lift-Alg )
open import Algebras.Func.Products               {𝑆 = 𝑆} using ( ⨅ )
open import Homomorphisms.Func.Basic             {𝑆 = 𝑆} using ( IsHom )
open import Homomorphisms.Func.Isomorphisms      {𝑆 = 𝑆} using ( _≅_ ; ≅-trans ; ≅-sym ; Lift-≅ ; ⨅≅⨅ℓ )
open import Homomorphisms.Func.HomomorphicImages {𝑆 = 𝑆} using ( _IsHomImageOf_ ; IdHomImage )
open import Subalgebras.Func.Subalgebras         {𝑆 = 𝑆} using ( _≤_ ; _≤c_ )
open import Subalgebras.Func.Properties          {𝑆 = 𝑆} using ( ≤-reflexive ; ≤-trans ; ≅-trans-≤
                                                               ; Lift-≤-Lift)

Lift-class : {α β γ : Level} → Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra γ γ) (γ ⊔ ov (α ⊔ β))
Lift-class {α}{β}{γ} 𝒦 = λ (𝑩 : SetoidAlgebra γ γ)
 →  Σ[ 𝑨 ∈ SetoidAlgebra α α ]  (𝑨 ∈ 𝒦)  ∧  (Lift-Alg 𝑨 (lsuc β) (lsuc β) ≅ 𝑩)

Lift-class' : {α β γ : Level} → Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra γ γ) (γ ⊔ β ⊔ ov α)
Lift-class' {α}{β}{γ} 𝒦 = λ (𝑩 : SetoidAlgebra γ γ) → Σ[ 𝑨 ∈ SetoidAlgebra α α ] 𝑨 ∈ 𝒦 ∧ Lift-Alg 𝑨 β β ≅ 𝑩

Lift-class-lemma : {α β γ : Level}{𝒦 : Pred(SetoidAlgebra α α) (ov α)}{𝑨 : SetoidAlgebra α α}
 →                 𝑨 ∈ 𝒦 → Lift-Alg 𝑨 γ γ ∈ (Lift-class {α}{β}{α ⊔ γ}𝒦)
Lift-class-lemma {𝑨 = 𝑨} kA = 𝑨 , (kA , (≅-trans (≅-sym Lift-≅) Lift-≅))

Lift-class-lemma' : {α β γ : Level}{𝒦 : Pred(SetoidAlgebra α α) (ov α)}{𝑨 : SetoidAlgebra α α}
 →                 𝑨 ∈ 𝒦 → Lift-Alg 𝑨 γ γ ∈ (Lift-class' {α}{β}{α ⊔ γ}𝒦)
Lift-class-lemma' {𝑨 = 𝑨} kA = 𝑨 , (kA , (≅-trans (≅-sym Lift-≅) Lift-≅))

private variable
 α β γ : Level


-- H : {α : Level} → Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra (ov α) (ov α)) (ov α)
H : Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra α α) (ov α)
H 𝒦 𝑩 = Σ[ 𝑨 ∈ SetoidAlgebra _ _ ] 𝑨 ∈ 𝒦 ∧ 𝑩 IsHomImageOf 𝑨

S : Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra α α) (ov α)
S 𝒦 𝑩 = Σ[ 𝑨 ∈ SetoidAlgebra _ _ ] 𝑨 ∈ 𝒦 ∧ 𝑩 ≤ 𝑨

P : Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra α α) (ov α)
P {α} 𝒦 𝑩 = Σ[ I ∈ Type α ] (Σ[ 𝒜 ∈ (I → SetoidAlgebra _ _) ] (∀ i → 𝒜 i ∈ 𝒦) ∧ (𝑩 ≅ ⨅ 𝒜))

V : Pred(SetoidAlgebra α α) (ov α) → Pred(SetoidAlgebra α α) (ov α)
V 𝒦 = H (S (P 𝒦))

-- These classes are closed under lifts.
P-Lift-closed : ∀ {α β 𝒦 𝑨} → 𝑨 ∈ P{α} 𝒦
 →              Lift-Alg 𝑨 β β ∈ P (Lift-class{α = α}{β}{α ⊔ β} 𝒦)
P-Lift-closed {β = β}{𝒦}{𝑨}(I , (𝒜 , (kA , A≅⨅A))) = Lift β I
                                                    , (λ x → Lift-Alg (𝒜 (lower x)) β β)
                                                    , Goal
 where
 Goal : ((i : Lift β I) → Lift-Alg (𝒜 (lower i)) β β ∈ Lift-class 𝒦)
      ∧ (Lift-Alg 𝑨 β β ≅ ⨅ (λ x → Lift-Alg (𝒜 (lower x)) β β))
 Goal = (λ i → Lift-class-lemma (kA (lower i))) , ≅-trans (≅-sym Lift-≅) (≅-trans A≅⨅A ⨅≅⨅ℓ) -- ⨅A≅⨅lA)


\end{code}

Thus, if 𝒦 is a class of 𝑆-algebras, then the *variety generated by* 𝒦 is denoted by `V 𝒦` and defined to be the smallest class that contains 𝒦 and is closed under `H`, `S`, and `P`.

With the closure operator V representing closure under HSP, we represent formally what it means to be a variety of algebras as follows.

\begin{code}

is-variety : (𝒱 : Pred (SetoidAlgebra α α) (ov α)) → Type (ov α)
is-variety 𝒱 = V 𝒱 ⊆ 𝒱

variety : {α : Level} → Type (ov (ov α))
variety {α} = Σ[ 𝒱 ∈ (Pred (SetoidAlgebra α α) (ov α)) ] is-variety 𝒱

\end{code}

#### <a id="closure-properties-of-S">Closure properties of S</a>

`S` is a closure operator.  The fact that S is expansive won't be needed, so we omit the proof, but we will make use of monotonicity and idempotence of `S`.  Here are their proofs.

\begin{code}

S-mono : {𝒦 𝒦' : Pred (SetoidAlgebra α α)(ov α)}
  →       𝒦 ⊆ 𝒦' → S 𝒦 ⊆ S 𝒦'
S-mono kk {𝑩} (𝑨 , (kA , B≤A)) = 𝑨 , ((kk kA) , B≤A)

S-idem : {𝒦 : Pred (SetoidAlgebra α α)(ov α)}
  →       S (S 𝒦) ⊆ S 𝒦
S-idem (𝑨 , (𝑩 , sB , A≤B) , x≤A) = 𝑩 , (sB , ≤-trans x≤A A≤B)

\end{code}


#### <a id="closure-properties-of-P">Closure properties of P</a>

`P` is a closure operator.  This is proved by checking that `P` is *monotone*, *expansive*, and *idempotent*. The meaning of these terms will be clear from the definitions of the types that follow.

\begin{code}

module _ {𝒦 : Pred (SetoidAlgebra α α)(ov α)} where

 P-mono : {𝒦' : Pred(SetoidAlgebra α α)(ov α)}
  →       𝒦 ⊆ 𝒦' → P 𝒦 ⊆ P 𝒦'

 P-mono kk {𝑩} (I , 𝒜 , (kA , B≅⨅A)) = I , (𝒜 , ((λ i → kk (kA i)) , B≅⨅A))

 open Func renaming ( f to _⟨$⟩_ )
 open _≅_
 open IsHom


 H-expa : 𝒦 ⊆ H 𝒦
 H-expa {𝑨} kA = 𝑨 , kA , IdHomImage

 S-expa : 𝒦 ⊆ S 𝒦
 S-expa {𝑨} kA = 𝑨 , (kA , ≤-reflexive)

 P-expa : 𝒦 ⊆ P 𝒦
 P-expa {𝑨} kA = ⊤ , (λ x → 𝑨) , ((λ i → kA) , Goal)
  where
  open SetoidAlgebra 𝑨 using () renaming (Domain to A)
  open SetoidAlgebra (⨅ (λ _ → 𝑨)) using () renaming (Domain to ⨅A)
  open Setoid A using ( refl )
  open Setoid ⨅A using () renaming ( refl to refl⨅ )

  to⨅ : Func A ⨅A
  (to⨅ ⟨$⟩ x) = λ _ → x
  cong to⨅ xy = λ _ → xy
  to⨅IsHom : IsHom 𝑨 (⨅ (λ _ → 𝑨)) to⨅
  compatible to⨅IsHom =  refl⨅

  from⨅ : Func ⨅A A
  (from⨅ ⟨$⟩ x) = x tt
  cong from⨅ xy = xy tt
  from⨅IsHom : IsHom (⨅ (λ _ → 𝑨)) 𝑨 from⨅
  compatible from⨅IsHom = refl

  Goal : 𝑨 ≅ ⨅ (λ x → 𝑨)
  to Goal = to⨅ , to⨅IsHom
  from Goal = from⨅ , from⨅IsHom
  to∼from Goal = λ _ _ → refl
  from∼to Goal = λ _ → refl


V-expa : {𝒦 : Pred (SetoidAlgebra α α)(ov α)}
 →        𝒦 ⊆ V 𝒦
V-expa {α} {𝒦} {𝑨} x = H-expa (S-expa (P-expa x))

\end{code}

We sometimes want to go back and forth between our two representations of subalgebras of algebras in a class. The tools `subalgebra→S` and `S→subalgebra` are made for that purpose.

\begin{code}

module _ {𝒦 : Pred (SetoidAlgebra α α)(ov α)} where

 subalgebra→S : {𝑩 : SetoidAlgebra α α} → 𝑩 ≤c 𝒦 → 𝑩 ∈ S 𝒦
 subalgebra→S = id

 S→subalgebra : {𝑩 : SetoidAlgebra α α} → 𝑩 ∈ S 𝒦  →  𝑩 ≤c 𝒦
 S→subalgebra = id


module _ {𝒦 : Pred (SetoidAlgebra α α)(ov α)} where

 S-Lift-lemma : {γ : Level}
  →             Lift-class{β = (α ⊔ γ)}{α ⊔ γ} (S 𝒦) ⊆ S (Lift-class{β = (α ⊔ γ)}{α ⊔ γ} 𝒦)

 S-Lift-lemma {γ} {𝑩} (𝑨 , (𝑪 , (kC , A≤C)) , lA≅B) = Goal
  where
  lklC : Lift-Alg 𝑪 γ γ ∈ Lift-class 𝒦
  lklC = Lift-class-lemma kC
  slklA : Lift-Alg 𝑨 γ γ ∈ S (Lift-class 𝒦)
  slklA = (Lift-Alg 𝑪 γ γ) , (lklC , (Lift-≤-Lift A≤C))


  Goal : 𝑩 ∈ S (Lift-class 𝒦)
  Goal = (Lift-Alg 𝑪 γ γ) , (lklC , ≅-trans-≤ (≅-sym lA≅B) (Lift-≤-Lift A≤C))




\end{code}

--------------------------------

<span style="float:left;">[← Varieties.Func.SoundAndComplete](Varieties.Func.SoundAndComplete.html)</span>
<span style="float:right;">[Varieties.Func.Properties →](Varieties.Func.Properties.html)</span>

{% include UALib.Links.md %}











<!-- open Level

-- module _ {𝑨 : SetoidAlgebra α α}{𝒦 : Pred (SetoidAlgebra α α)(ov α)} where
--  sk→lsk : {β : Level} → 𝑨 ∈ S 𝒦 → Lift-Alg 𝑨 β β ∈ S (Lift-class {β = (α ⊔ β)} 𝒦)
--  sk→lsk sA = {!!}



P-idemp : {𝒦 : Pred (SetoidAlgebra α α)(ov α)}
 →        P (P 𝒦) ⊆ P 𝒦
P-idemp {α} {𝒦} {𝑨} (I , (𝒜 , (P𝒜 , A≅⨅A))) = {!!}

-->
