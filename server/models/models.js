const sequelize = require('../db')
const {DataTypes} = require('sequelize')

const Page = sequelize.define('indexed', {
    id: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    url: {type: DataTypes.STRING, unique: true, defaultValue: "https://google.com"},
    header: {type: DataTypes.TEXT, defaultValue: "Header"},
    text: {type: DataTypes.TEXT, defaultValue: "Text"},
})

module.exports = {
    Page
}