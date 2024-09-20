# SmartContractVoting
# Ballot - Bir Solidity Oylama Sözleşmesi

Bu proje, Ethereum blok zinciri üzerinde Solidity kullanarak güvenli ve şeffaf bir oylama süreci uygular. Ballot sözleşmesi, kullanıcılara seçimlere katılma, oylarını devretme ve oylama süresi dolmadan oylarını geri çekme yetkisi verir. Başkan, yeni teklifler ekleme ve kazananı ilan etme dahil olmak üzere oylama süreci üzerinde kontrol sahibi olur.

## Özellikler

* **Oylama:** Kayıtlı seçmenler tercih ettikleri tekliflere oy verebilirler.
* **Devretme:** Seçmenler oy verme güçlerini diğer seçmenlere devredebilirler.
* **Geri Çekme:** Seçmenler, son teslim tarihinden önce fikirlerini değiştirirlerse oylarını geri çekme esnekliğine sahiptir.
* **Teklif Ekleme:** Başkan, oylama dönemi boyunca yeni teklifler ekleyebilir.
* **Kazananı İlan Etme:** Başkan, oylama sona erdiğinde kazanan teklifi ve oy sayısını ilan edebilir.
* **Oylama Son Tarihi:** Oylama süreci, zamanında sonuç alınmasını sağlayan önceden tanımlanmış bir son tarih ile sınırlıdır.

## Başlarken

1. **Ön Koşullar:** Solidity ve bir Ethereum istemcisi (örneğin, Ganache, Remix) ile bir geliştirme ortamınızın kurulu olduğundan emin olun.

2. **Dağıtım:** `Ballot` sözleşmesini derleyin ve tercih ettiğiniz Ethereum ağına dağıtın.

3. **Etkileşim:** Sözleşmenin işlevlerini kullanarak:
   * `giveRightToVote`: Uygun seçmenlere oy hakkı verin (yalnızca başkan).
   * `delegate`: Oy verme gücünü başka bir seçmene devredin.
   * `vote`: Bir teklife oy verin.
   * `retractVote`: Daha önce verdiğiniz oyu geri çekin.
   * `addProposal`: Yeni bir teklif ekleyin (yalnızca başkan).
   * `announceWinner`: Kazanan teklifi ve oy sayısını ilan edin (yalnızca başkan).

## Önemli Hususlar

* **Güvenlik:** Sözleşme, belirli eylemleri başkanla sınırlamak ve oylama süresini uygulamak için değiştiriciler içerir.
* **Şeffaflık:** Oylama sonuçları blok zincirinde herkese açık olarak görüntülenebilir.
* **Esneklik:** Oyları geri çekme ve yeni teklifler ekleme yeteneği, oylama sürecine uyarlanabilirlik katar.

## Katkılar

Katkılar bekliyoruz! Lütfen sorunları bildirmekten veya pull request'ler göndermekten çekinmeyin.

## Teşekkürler

* İlham ve rehberlik için Solidity belgelerine.

## Sorumluluk Reddi

Bu kod, eğitim ve örnek amaçlı sağlanmıştır. Kendi sorumluluğunuzda kullanın ve bir üretim ortamına dağıtmadan önce kapsamlı testler yaptığınızdan emin olun.
