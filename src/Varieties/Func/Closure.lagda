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
open import Agda.Primitive        using ( _⊔_ ; lsuc ) renaming ( Set to Type ; lzero to ℓ₀)
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
open import Homomorphisms.Func.Isomorphisms      {𝑆 = 𝑆} using ( _≅_ ; ≅-trans ; ≅-sym ; Lift-≅ ; ⨅≅⨅ℓρ )
open import Homomorphisms.Func.HomomorphicImages {𝑆 = 𝑆} using ( _IsHomImageOf_ ; IdHomImage ; HomImage-≅
                                                               ; HomImage-≅' ; Lift-HomImage-lemma )
open import Subalgebras.Func.Subalgebras         {𝑆 = 𝑆} using ( _≤_ ; _≤c_ )
open import Subalgebras.Func.Properties          {𝑆 = 𝑆} using ( ≤-reflexive ; ≤-trans ; ≅-trans-≤ ; ≤-trans-≅
                                                               ; Lift-≤-Lift ; ≤-Lift )

open Func renaming ( f to _⟨$⟩_ )

module _ {α ρᵃ β ρᵇ : Level} where

 private a = α ⊔ ρᵃ ; b = β ⊔ ρᵇ

 Level-closure : ∀ ℓ → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) → Pred(SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ))
 Level-closure ℓ 𝒦 𝑩 = Σ[ 𝑨 ∈ SetoidAlgebra α ρᵃ ]  (𝑨 ∈ 𝒦)  ∧  𝑨 ≅ 𝑩

module _ {α ρᵃ β ρᵇ : Level} where

 Lift-closed : ∀ ℓ → {𝒦 : Pred(SetoidAlgebra α ρᵃ) _}{𝑨 : SetoidAlgebra α ρᵃ} → 𝑨 ∈ 𝒦
  →            Lift-Alg 𝑨 β ρᵇ ∈ (Level-closure ℓ 𝒦)
 Lift-closed _ {𝑨 = 𝑨} kA = 𝑨 , (kA , Lift-≅)

module _  {α ρᵃ β ρᵇ : Level} where

 private a = α ⊔ ρᵃ ; b = β ⊔ ρᵇ

 H : ∀ ℓ → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) → Pred(SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ))
 H _ 𝒦 𝑩 = Σ[ 𝑨 ∈ SetoidAlgebra α ρᵃ ] 𝑨 ∈ 𝒦 ∧ 𝑩 IsHomImageOf 𝑨

 S : ∀ ℓ → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) → Pred(SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ))
 S _ 𝒦 𝑩 = Σ[ 𝑨 ∈ SetoidAlgebra α ρᵃ ] 𝑨 ∈ 𝒦 ∧ 𝑩 ≤ 𝑨

 P : ∀ ℓ ι → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) → Pred(SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ ⊔ ι))
 P ℓ ι 𝒦 𝑩 = Σ[ I ∈ Type ι ] (Σ[ 𝒜 ∈ (I → SetoidAlgebra α ρᵃ) ] (∀ i → 𝒜 i ∈ 𝒦) ∧ (𝑩 ≅ ⨅ 𝒜))

module _  {α ρᵃ β ρᵇ : Level} where

 private a = α ⊔ ρᵃ ; b = β ⊔ ρᵇ

 SP : ∀ ℓ ι → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) → Pred(SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ ⊔ ι))
 SP ℓ ι 𝒦 = S{α}{ρᵃ} (a ⊔ ℓ ⊔ ι) (P ℓ ι 𝒦)

module _  {α ρᵃ β ρᵇ γ ρᶜ δ ρᵈ : Level} where

 private a = α ⊔ ρᵃ ; b = β ⊔ ρᵇ ; c = γ ⊔ ρᶜ ; d = δ ⊔ ρᵈ

 V : ∀ ℓ ι → Pred(SetoidAlgebra α ρᵃ) (a ⊔ ov ℓ) →  Pred(SetoidAlgebra δ ρᵈ) (d ⊔ ov(a ⊔ b ⊔ c ⊔ ℓ ⊔ ι))
 V ℓ ι 𝒦 = H{γ}{ρᶜ}{δ}{ρᵈ} (a ⊔ b ⊔ ℓ ⊔ ι) (S{β}{ρᵇ} (a ⊔ ℓ ⊔ ι) (P ℓ ι 𝒦))

\end{code}



Thus, if 𝒦 is a class of 𝑆-algebras, then the *variety generated by* 𝒦 is denoted by `V 𝒦` and defined to be the smallest class that contains 𝒦 and is closed under `H`, `S`, and `P`.

With the closure operator V representing closure under HSP, we represent formally what it means to be a variety of algebras as follows.

\begin{code}

module _ {α ρᵃ ℓ ι : Level} where

 is-variety : (𝒱 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)) → Type (ov (α ⊔ ρᵃ ⊔ ℓ ⊔ ι))
 is-variety 𝒱 = V{β = α}{ρᵇ = ρᵃ}{γ = α}{ρᶜ = ρᵃ} ℓ ι 𝒱 ⊆ 𝒱

 variety : Type (ov (α ⊔ ρᵃ ⊔ ov ℓ ⊔ ι))
 variety = Σ[ 𝒱 ∈ (Pred (SetoidAlgebra α ρᵃ) (α ⊔ ρᵃ ⊔ ov ℓ)) ] is-variety 𝒱

\end{code}

#### <a id="closure-properties-of-S">Closure properties of S</a>

`S` is a closure operator.  The fact that S is expansive won't be needed, so we omit the proof, but we will make use of monotonicity and idempotence of `S`.  Here are their proofs.

\begin{code}
module _ {α ρᵃ ℓ : Level} where

 S-mono : {𝒦 𝒦' : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)}
  →       𝒦 ⊆ 𝒦' → S{β = α}{ρᵃ} ℓ 𝒦 ⊆ S ℓ 𝒦'
 S-mono kk {𝑩} (𝑨 , (kA , B≤A)) = 𝑨 , ((kk kA) , B≤A)

 S-idem' : {𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)}
  →       S{lsuc α}{lsuc ρᵃ}{α}{ρᵃ} ℓ (S ℓ 𝒦) ⊆ S ℓ 𝒦
 S-idem' (𝑨 , (𝑩 , sB , A≤B) , x≤A) = 𝑩 , (sB , ≤-trans x≤A A≤B)


module _ {α ρᵃ β ρᵇ γ ρᶜ ℓ : Level} where

 S-idem : {𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)}
  →       S{β}{ρᵇ}{γ}{ρᶜ} (α ⊔ ρᵃ ⊔ ℓ) (S{β = β}{ρᵇ} ℓ 𝒦) ⊆ S{β = γ}{ρᶜ} ℓ 𝒦
 S-idem (𝑨 , (𝑩 , sB , A≤B) , x≤A) = 𝑩 , (sB , ≤-trans x≤A A≤B)

\end{code}


#### <a id="closure-properties-of-P">Closure properties of P</a>

`P` is a closure operator.  This is proved by checking that `P` is *monotone*, *expansive*, and *idempotent*. The meaning of these terms will be clear from the definitions of the types that follow.

\begin{code}

module _ {α ρᵃ : Level} where

 private a = α ⊔ ρᵃ

 H-expa : ∀ ℓ → {𝒦 : Pred (SetoidAlgebra α ρᵃ)(a ⊔ ov ℓ)} → 𝒦 ⊆ H ℓ 𝒦
 H-expa _ {𝒦}{𝑨} kA = 𝑨 , kA , IdHomImage

 S-expa : ∀ ℓ → {𝒦 : Pred (SetoidAlgebra α ρᵃ)(a ⊔ ov ℓ)} → 𝒦 ⊆ S ℓ 𝒦
 S-expa _ {𝒦}{𝑨} kA = 𝑨 , (kA , ≤-reflexive)

 P-mono : ∀ ℓ ι → {𝒦 𝒦' : Pred (SetoidAlgebra α ρᵃ)(a ⊔ ov ℓ)}
  →       𝒦 ⊆ 𝒦' → P{β = α}{ρᵃ} ℓ ι 𝒦 ⊆ P ℓ ι 𝒦'

 P-mono _ _ {𝒦}{𝒦'} kk {𝑩} (I , 𝒜 , (kA , B≅⨅A)) = I , (𝒜 , ((λ i → kk (kA i)) , B≅⨅A))

 open _≅_
 open IsHom


 P-expa : ∀ ℓ ι → {𝒦 : Pred (SetoidAlgebra α ρᵃ)(a ⊔ ov ℓ)} → 𝒦 ⊆ P{β = α}{ρᵃ} ℓ ι 𝒦
 P-expa _ _ {𝒦}{𝑨} kA = ⊤ , (λ x → 𝑨) , ((λ i → kA) , Goal)
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

 V-expa : ∀ ℓ ι → {𝒦 : Pred (SetoidAlgebra α ρᵃ)(a ⊔ ov ℓ)}
  →       𝒦 ⊆ V ℓ ι 𝒦
 V-expa ℓ ι {𝒦} {𝑨} x = H-expa (a ⊔ ℓ ⊔ ι) (S-expa (a ⊔ ℓ ⊔ ι) (P-expa ℓ ι x) )

\end{code}

We sometimes want to go back and forth between our two representations of subalgebras of algebras in a class. The tools `subalgebra→S` and `S→subalgebra` are made for that purpose.

\begin{code}

module _ {α ρᵃ β ρᵇ ℓ ι : Level}{𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)}
         {𝑨 : SetoidAlgebra α ρᵃ}{𝑩 : SetoidAlgebra β ρᵇ} where

 S-≅ : 𝑨 ∈ S ℓ 𝒦 → 𝑨 ≅ 𝑩 → 𝑩 ∈ S{α ⊔ β}{ρᵃ ⊔ ρᵇ}(α ⊔ ρᵃ ⊔ ℓ) (Level-closure ℓ 𝒦)
 S-≅ (𝑨' , kA' , A≤A') A≅B = lA' , (lklA' , B≤lA')
  where
  lA' : SetoidAlgebra (α ⊔ β) (ρᵃ ⊔ ρᵇ)
  lA' = Lift-Alg 𝑨' β ρᵇ
  lklA' : lA' ∈ Level-closure ℓ 𝒦
  lklA' = Lift-closed ℓ kA'
  subgoal : 𝑨 ≤ lA'
  subgoal = ≤-trans-≅ A≤A' Lift-≅
  B≤lA' : 𝑩 ≤ lA'
  B≤lA' = ≅-trans-≤ (≅-sym A≅B) subgoal


 V-≅ : 𝑨 ∈ V ℓ ι 𝒦 → 𝑨 ≅ 𝑩 → 𝑩 ∈ V{β = α}{ρᵃ} ℓ ι 𝒦
 V-≅ (𝑨' , spA' , AimgA') A≅B = 𝑨' , spA' , HomImage-≅ AimgA' A≅B


module _ {α ρᵃ ℓ : Level}
         (𝒦 : Pred(SetoidAlgebra α ρᵃ) (α ⊔ ρᵃ ⊔ ov ℓ))
         (𝑨 : SetoidAlgebra (α ⊔ ρᵃ ⊔ ℓ) (α ⊔ ρᵃ ⊔ ℓ)) where

 private
  ι = ov(α ⊔ ρᵃ ⊔ ℓ)

 V-≅-lc : Lift-Alg 𝑨 ι ι ∈ V{β = ι}{ι} ℓ ι 𝒦
  →       𝑨 ∈ V{γ = ι}{ι} ℓ ι 𝒦

 V-≅-lc (𝑨' , spA' , lAimgA') = 𝑨' , (spA' , AimgA')
  where
  AimgA' : 𝑨 IsHomImageOf 𝑨'
  AimgA' = Lift-HomImage-lemma lAimgA'

\end{code}

The remaining theorems in this file are as yet unused, but may be useful later and/or for reference.

\begin{code}

module _ {α ρᵃ ℓ ι : Level}{𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)} where

 -- For reference, some useful type levels:
 classP : Pred (SetoidAlgebra α ρᵃ) (ov(α ⊔ ρᵃ ⊔ ℓ ⊔ ι))
 classP = P{β = α}{ρᵃ} ℓ ι 𝒦

 classSP : Pred (SetoidAlgebra α ρᵃ) (ov(α ⊔ ρᵃ ⊔ ℓ ⊔ ι))
 classSP = S{β = α}{ρᵃ} (α ⊔ ρᵃ ⊔ ℓ ⊔ ι) (P{β = α}{ρᵃ} ℓ ι 𝒦)

 classHSP : Pred (SetoidAlgebra α ρᵃ) (ov(α ⊔ ρᵃ ⊔ ℓ ⊔ ι))
 classHSP = H{β = α}{ρᵃ}(α ⊔ ρᵃ ⊔ ℓ ⊔ ι) (S{β = α}{ρᵃ}(α ⊔ ρᵃ ⊔ ℓ ⊔ ι) (P{β = α}{ρᵃ}ℓ ι 𝒦))

module _ {α ρᵃ β ρᵇ ℓ : Level}{𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)} where
 private a = α ⊔ ρᵃ ; b = β ⊔ ρᵇ

 -- For reference, some useful type levels:
 classS : Pred (SetoidAlgebra β ρᵇ) (b ⊔ ov(a ⊔ ℓ))
 classS = S ℓ 𝒦
 classK : {γ ρᶜ : Level} → Pred (SetoidAlgebra γ ρᶜ) (γ ⊔ ρᶜ ⊔ ov(a ⊔ ℓ))
 classK {γ}{ρᶜ} = Level-closure{α}{ρᵃ} ℓ 𝒦

 LevelClosure-S : {γ ρᶜ : Level} → Pred (SetoidAlgebra (α ⊔ γ) (ρᵃ ⊔ ρᶜ)) (γ ⊔ ρᶜ ⊔ ov(a ⊔ b ⊔ ℓ))
 LevelClosure-S {γ}{ρᶜ} = Level-closure{β}{ρᵇ} (a ⊔ ℓ) (S ℓ 𝒦)

 S-LevelClosure : {γ ρᶜ : Level} → Pred (SetoidAlgebra (α ⊔ γ) (ρᵃ ⊔ ρᶜ)) (ov(a ⊔ ℓ ⊔ γ ⊔ ρᶜ))
 S-LevelClosure {γ}{ρᶜ} = S{α ⊔ γ}{ρᵃ ⊔ ρᶜ}(a ⊔ ℓ) (Level-closure ℓ 𝒦)

 S-Lift-lemma : {γ ρᶜ : Level} → LevelClosure-S {γ}{ρᶜ} ⊆ S-LevelClosure {γ}{ρᶜ}
 S-Lift-lemma {γ}{ρᶜ} {𝑪} (𝑩 , (𝑨 , (kA , B≤A)) , B≅C) = Lift-Alg 𝑨 γ ρᶜ
                                                       , (Lift-closed{β = γ}{ρᶜ} ℓ kA)
                                                       , C≤lA
  where
  B≤lA : 𝑩 ≤ Lift-Alg 𝑨 γ ρᶜ
  B≤lA = ≤-Lift B≤A
  C≤lA : 𝑪 ≤ Lift-Alg 𝑨 γ ρᶜ
  C≤lA = ≅-trans-≤ (≅-sym B≅C) B≤lA



module _ {α ρᵃ : Level} where

 P-Lift-closed : ∀ ℓ ι → {𝒦 : Pred (SetoidAlgebra α ρᵃ)(α ⊔ ρᵃ ⊔ ov ℓ)}{𝑨 : SetoidAlgebra α ρᵃ}
  →              𝑨 ∈ P{β = α}{ρᵃ} ℓ ι 𝒦
  →              {γ ρᶜ : Level} → Lift-Alg 𝑨 γ ρᶜ ∈ P (α ⊔ ρᵃ ⊔ ℓ) ι (Level-closure ℓ 𝒦)
 P-Lift-closed ℓ ι {𝒦}{𝑨} (I , 𝒜 , kA , A≅⨅𝒜) {γ}{ρᶜ} = I
                                                        , (λ x → Lift-Alg (𝒜 x) γ ρᶜ)
                                                        , goal1 , goal2

  where
  goal1 : (i : I) → Lift-Alg (𝒜 i) γ ρᶜ ∈ Level-closure ℓ 𝒦
  goal1 i = Lift-closed ℓ (kA i)
  goal2 : Lift-Alg 𝑨 γ ρᶜ ≅ ⨅ (λ x → Lift-Alg (𝒜 x) γ ρᶜ)
  goal2 = ≅-trans (≅-sym Lift-≅) (≅-trans A≅⨅𝒜 (⨅≅⨅ℓρ{ℓ = γ}{ρ = ρᶜ}))

\end{code}


--------------------------------

<span style="float:left;">[← Varieties.Func.SoundAndComplete](Varieties.Func.SoundAndComplete.html)</span>
<span style="float:right;">[Varieties.Func.Properties →](Varieties.Func.Properties.html)</span>

{% include UALib.Links.md %}

