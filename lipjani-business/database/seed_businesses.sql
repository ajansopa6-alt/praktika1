-- Curated starter listings from public business listings and OpenStreetMap.
-- Re-import is safe: a business with the same name is not inserted twice.
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,hours_json,status,is_featured)
SELECT NULL,c.id,'Proper Pizza - Lipjan','Piceri në rrugën Hajredin Bajrami, Lipjan.','+383 45 208 283','Rr. Hajredin Bajrami, Lipjan 14000',42.5187900,21.1217500,NULL,'approved',1
FROM categories c WHERE c.sort_order=1
AND NOT EXISTS(SELECT 1 FROM businesses b WHERE LOWER(b.name)=LOWER('Proper Pizza - Lipjan'));

INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,hours_json,status,is_featured)
SELECT NULL,c.id,'Pa Lek Pizza','Piceri në rrugën Isa Olluri, Lipjan.','+383 45 922 911','Rr. Isa Olluri, Lipjan 14000',42.5208400,21.1204400,NULL,'approved',1
FROM categories c WHERE c.sort_order=1
AND NOT EXISTS(SELECT 1 FROM businesses b WHERE LOWER(b.name)=LOWER('Pa Lek Pizza'));

INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,hours_json,status,is_featured)
SELECT NULL,c.id,'Rozafa-1 Lipjan','Restorant në rrugën Hajredin Bajrami, Lipjan.','+383 44 103 888','Rr. Hajredin Bajrami, Lipjan 14000',42.5189100,21.1223700,NULL,'approved',1
FROM categories c WHERE c.sort_order=1
AND NOT EXISTS(SELECT 1 FROM businesses b WHERE LOWER(b.name)=LOWER('Rozafa-1 Lipjan'));

UPDATE businesses SET category_id=(SELECT id FROM categories WHERE sort_order=1),description='Piceri në rrugën Hajredin Bajrami, Lipjan.',phone='+383 45 208 283',address='Rr. Hajredin Bajrami, Lipjan 14000',latitude=42.5187900,longitude=21.1217500 WHERE name='Proper Pizza - Lipjan';
UPDATE businesses SET category_id=(SELECT id FROM categories WHERE sort_order=1),description='Piceri në rrugën Isa Olluri, Lipjan.',phone='+383 45 922 911',address='Rr. Isa Olluri, Lipjan 14000',latitude=42.5208400,longitude=21.1204400 WHERE name='Pa Lek Pizza';
UPDATE businesses SET category_id=(SELECT id FROM categories WHERE sort_order=1),description='Restorant në rrugën Hajredin Bajrami, Lipjan.',phone='+383 44 103 888',address='Rr. Hajredin Bajrami, Lipjan 14000',latitude=42.5189100,longitude=21.1223700 WHERE name='Rozafa-1 Lipjan';
-- Additional verified Lipjan businesses. Category references use stable sort_order IDs.
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=1),'7 Vellezerit Restaurant','Restaurant in central Lipjan serving local and international food.','+383 44 274 188','8 Haradin Bajrami, Lipjan 14000',42.5191700,21.1219100,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('7 Vellezerit Restaurant'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=4),'Interex Lipjan','Supermarket on Avdi Kelmendi in Lipjan.','+383 48 160 113','Avdi Kelmendi, Lipjan 14000',42.5267300,21.1193800,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('Interex Lipjan'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=4),'KAM Market Lipjan','Supermarket on Skenderbeu in Lipjan.','','Skenderbeu, Lipjan 14000',42.5203600,21.1243500,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('KAM Market Lipjan'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=1),'Restaurant Berlin','Restaurant on Shen Flori in Lipjan.','+383 44 848 481','Shen Flori, Lipjan 14000',42.5256100,21.1196800,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('Restaurant Berlin'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=1),'Rafaello Restaurant','Restaurant in Lipjan.','','Lipjan 14000',42.5267700,21.1193800,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('Rafaello Restaurant'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=12),'Neptun Lipjan','Electronics store on Avdi Kelmendi in Lipjan.','+383 45 999 520','Avdi Kelmendi, Lipjan 14000',42.5269800,21.1188800,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('Neptun Lipjan'));
INSERT INTO businesses(owner_id,category_id,name,description,phone,address,latitude,longitude,status,is_featured)
SELECT NULL,(SELECT id FROM categories WHERE sort_order=3),'Hotel Arbëri','Hotel in Lipjan.','+383 44 477 776','R120, Lipjan 14000',42.5199800,21.1362800,'approved',0
WHERE NOT EXISTS(SELECT 1 FROM businesses WHERE LOWER(name)=LOWER('Hotel Arbëri'));