const { DAO } = require('./dao');

const dao = new DAO('articles');

dao.findAll = async () => {
  const rows = await dao.query(
    'SELECT * FROM vue_articles WHERE id_liste IS NULL'
  );
  return rows[0];
};

dao.findAllByListId = async listId => {
  const rows = await dao.query(
    'SELECT * FROM vue_articles WHERE id_liste = ?',
    [listId]
  );
  return rows[0];
};

dao.deleteOneByIdAndList = async (articleId, listId) => {
  // Suppresion des références à l'article pour une liste donnée
  await dao.query(
    'DELETE FROM articles_listes WHERE id_article=? AND id_liste = ?',
    [articleId, listId]
  );
  // Récupération des références à l'article après suppression dans la liste
  // l'article est-il dans une ou plusieurs autres listes
  const articleExists = await dao.query(
    'SELECT a.id FROM vue_articles as a WHERE id_liste is not null and id=?',
    [articleId]
  );

  console.log(articleExists[0]);

  // Si l'article n'existe plus dans aucune liste
  if (articleExists[0].length == 0) {
    // Suppression de l'article
    await dao.query('DELETE FROM articles WHERE id= ?', [articleId]);
  }
  const articleList = await dao.findAllByListId(listId);
  return articleList;
};

dao.deleteOneById = async articleId => {
  // Suppression de l'article
  await dao.query('DELETE FROM articles WHERE id= ?', [articleId]);
  // Liste des articles
  return await dao.findAll();
};

module.exports = dao;
