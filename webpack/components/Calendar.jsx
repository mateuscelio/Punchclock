import React from 'react';
import Form from './Form';
import Navbar from './Navbar';
import Week from './Week';
import Day from './Day';

export default class extends React.Component {
  weeksRender() {
    return this.props.Calendar.weeks.map((week, i)=> {
      return (
        <Week key={i} week={week} actions={this.props.actions} >
          { week.days.map((d, ii)=> {
          return (<Day
            key={ii}
            inner={d.inner}
            today={d.today}
            sheet={this.props.sheetFor(d)}
            actions={this.props.actions}
            selected={this.props.isSelected(d.day)}
            day={d.day} />);
          })}
        </Week>
      );
    });
  }

  render() {
    return (
      <div className="calendar-container">
        <Navbar
          hasNext={this.props.Calendar.hasNext}
          actions={this.props.actions}>
        {this.props.Calendar.monthNames}
        </Navbar>
        <table className='punches-table'>
          <thead><tr>
            {this.props.Calendar.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>{ this.weeksRender() }</tbody>
        </table>
        <p>Horas: { this.props.Sheets.sum }</p>
        <Form
          selecteds={this.props.Selection.selecteds}
          changes={this.props.Sheets.changes}
          actions={this.props.actions}
          save={this.props.serverActions.saveSheets} />
      </div>
    );
  }
};
