---
trigger: glob
globs: design/**,story/**,data/**,localization/**
description: Kanon ve kaynak içerik koruması
---
# Kanon ve kaynak içerik

- Hikâye, dünya ve karakter kanonu: `design/OYUN_BILGI_DOKUMANI.md`. Çelişen bir şey uydurma; yeni lore ekleme.
- **Part II sırlarını çözme ya da ifşa etme.**
- `story/ data/ localization/` ve `art/ audio/ fonts/` **salt okunur** kaynaktır: değiştirme, silme. Gerekenler işlenip `game/` altına alınır.
- Oyun tasarımı kararları (denge, UI, harita) `design/` altına ve `docs/ILERLEME.md` karar günlüğüne yazılır. Kanonu değiştirmeyen kararları kendin ver; kanonu ya da kilitli kararları değiştirmek için sor.
- `design/OYUN_TASARIM_PLANI.md` §5'teki Meshy / Tripo adımları **geçersizdir** (sahip kararı: modeller elle, kodla).
